extends Node
## Singleton global de "sOC the Game".
## Gestiona: transiciones de escena con fundido, mapa de entrada
## multiplataforma (teclado + preparado para tactil), ajustes y guardado.

const SETTINGS_PATH := "user://settings.cfg"
const SAVE_PATH := "user://savegame.json"

# --- Paleta compartida (estetica noche urbana / misterio) ---
const COL_BG_TOP := Color(0.055, 0.070, 0.105)
const COL_BG_BOTTOM := Color(0.010, 0.020, 0.030)
const COL_ACCENT := Color(0.86, 0.20, 0.20)      # rojo linterna / peligro
const COL_ACCENT_DIM := Color(0.45, 0.12, 0.12)
const COL_WARM := Color(0.95, 0.66, 0.38)         # calido antorcha
const COL_TEXT := Color(0.86, 0.88, 0.92)
const COL_TEXT_MUTED := Color(0.45, 0.50, 0.58)

# --- Tipografia (Kenney, CC0) ---
# Cuerpo por defecto (Kenney Future) fijado en project.godot.
const FONT_TITLE_PATH := "res://assets/fonts/Kenney Future Narrow.ttf"  # titulos
const FONT_ACCENT_PATH := "res://assets/fonts/Kenney High.ttf"          # frases atmosfericas
const FONT_BODY_PATH := "res://assets/fonts/Kenney Future.ttf"          # cuerpo (por defecto)
var font_title: Font
var font_accent: Font

var settings := {
	"master_volume": 0.9,
	"music_volume": 0.8,
	"sfx_volume": 0.9,
	"fullscreen": false,
	"language": "es",   # es | en | zh
}

# --- Localización (i18n) -------------------------------------------------------
# El TEXTO original está en español; la traducción se busca por el propio texto es
# en tablas cargadas de assets/i18n/. Si falta, cae a español. Idiomas oficiales del
# proyecto: castellano (es) e inglés (en). Ver constitución (idiomas oficiales).
const LANGUAGES := ["es", "en"]
const LANG_NAMES := {"es": "Español", "en": "English"}
# Banderas del selector de idioma (imagenes; los emoji de bandera no se renderizan
# como banderas en Windows/Godot). Dominio publico (banderas nacionales) -> ADR-040.
const LANG_FLAGS := {
	"es": "res://assets/ui/flag_es.png",
	"en": "res://assets/ui/flag_en.png",
}
var _tr := {"en": {}}   # lang -> {texto_es: traducción}

func language() -> String:
	return String(settings.get("language", "es"))

func set_language(lang: String) -> void:
	settings["language"] = lang
	save_settings()

## Traduce un texto (en español) al idioma actual; si no hay traducción, lo devuelve tal cual.
func loc(s: String) -> String:
	var lang := language()
	if lang == "es" or not _tr.has(lang):
		return s
	return String(_tr[lang].get(s, s))

func _load_translations() -> void:
	for lang in ["en"]:
		_tr[lang] = {}
		for fname in ["ui_%s.json" % lang, "dlg_%s.json" % lang]:
			var path: String = "res://assets/i18n/" + fname
			if not FileAccess.file_exists(path):
				continue
			var f := FileAccess.open(path, FileAccess.READ)
			if f == null:
				continue
			var data: Variant = JSON.parse_string(f.get_as_text())
			f.close()
			if typeof(data) == TYPE_DICTIONARY:
				_tr[lang].merge(data, true)

# Efectos de sonido (Kenney, CC0)
const SFX_CLICK := "res://assets/audio/kenney_interface-sounds/click_001.ogg"
const SFX_CONFIRM := "res://assets/audio/kenney_interface-sounds/confirmation_001.ogg"
const SFX_BACK := "res://assets/audio/kenney_interface-sounds/back_001.ogg"
const SFX_FOOTSTEP := "res://assets/audio/kenney_rpg-audio/footstep%02d.ogg"
const SFX_NOTE := "res://assets/audio/kenney_rpg-audio/bookOpen.ogg"

var _fade: ColorRect
var _sfx_pool: Array = []
var _sfx_idx := 0

# Los diálogos NO llevan voz: ni blips sintetizados, ni TTS del sistema, ni audio
# pregrabado. Se probaron los tres (ver bitácora, 2026-07-14/15) y ninguno convencía:
# el diálogo se lee con la máquina de escribir y su SFX, y ya está.

# --- Caso / libreta de pistas ---
var chapter: int = 1       # capítulo actual (1..3)
var clues: Array = []      # [{title, text}]
var flags: Dictionary = {} # banderas de progreso (done_emilio, cap1_completo, ...)
var met_chars: Array = []  # claves CHARS de personajes conocidos (para el tablero dinámico)

## Modo herramienta: los scripts de tools/ recorren la historia mutando este
## singleton (reset_case, chapter, set_flag). Como set_flag/add_clue persisten,
## una ejecución de tools/ machacaba user://savegame.json con flags sin pistas y
## dejaba el tablero mostrando solo escenas. Con esto, save_game() no escribe.
var tool_mode := false

## Acentos/eñe -> ASCII, para que el nombre de fichero sea legible y portable.
const _SLUG_ASCII := {
	"á": "a", "à": "a", "ä": "a", "â": "a", "é": "e", "è": "e", "ë": "e", "ê": "e",
	"í": "i", "ì": "i", "ï": "i", "î": "i", "ó": "o", "ò": "o", "ö": "o", "ô": "o",
	"ú": "u", "ù": "u", "ü": "u", "û": "u", "ñ": "n", "ç": "c",
}

## Nombre de fichero de una pista a partir de su TÍTULO: "El pañuelo" -> "el-panuelo".
## Es la clave de assets/objects/<slug>.png y la comparte tools/gen_objects.py, que
## replica esta misma función en Python. El título siempre está en español (la
## traducción ocurre al pintar, con loc()), así que el slug no depende del idioma.
static func clue_slug(title: String) -> String:
	var out := ""
	for ch in title.to_lower():
		if _SLUG_ASCII.has(ch):
			out += String(_SLUG_ASCII[ch])
		elif (ch >= "a" and ch <= "z") or (ch >= "0" and ch <= "9"):
			out += ch
		else:
			out += "-"
	while out.contains("--"):
		out = out.replace("--", "-")
	out = out.lstrip("-").rstrip("-")
	if out.length() > 48:
		out = out.substr(0, 48)
	return out.rstrip("-")


## Ruta de la foto de objeto de una pista, o "" si esa pista no tiene foto (los
## conceptos abstractos no la tienen: solo se fotografían las pruebas tangibles).
## La usan el tablero (polaroid) y el diálogo (destello al descubrirla).
static func clue_image(title: String) -> String:
	if title == "":
		return ""
	var p := "res://assets/objects/%s.png" % clue_slug(title)
	return p if ResourceLoader.exists(p) else ""


func add_clue(title: String, text: String, is_false: bool = false) -> bool:
	for c in clues:
		if c.title == title:
			return false
	clues.append({"title": title, "text": text, "false": is_false})
	save_game()          # se guarda a cada pista encontrada
	return true

func set_flag(name: String, value: bool = true) -> void:
	flags[name] = value
	save_game()          # el progreso (banderas) también persiste

func has_flag(name: String) -> bool:
	return flags.get(name, false)

func reset_case() -> void:
	chapter = 0          # nueva partida arranca en el Capítulo 0 (tutorial); done_cierre0 pasa al Caso 1
	clues.clear()
	flags.clear()
	met_chars.clear()


## Registra un personaje conocido (para el tablero dinámico). Ignora narrador/detective.
func note_char(who: String) -> void:
	if who == "" or who == "narrador" or who == "detective" or who in met_chars:
		return
	met_chars.append(who)
	save_game()


# --- Guardado del progreso del caso (capítulo + pistas + banderas) ---
func save_game() -> void:
	if tool_mode:
		return           # tools/: nunca tocar la partida del jugador
	var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if f == null:
		return
	f.store_string(JSON.stringify({"chapter": chapter, "clues": clues, "flags": flags, "met_chars": met_chars}))
	f.close()


func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if f == null:
		return false
	var data: Variant = JSON.parse_string(f.get_as_text())
	f.close()
	if typeof(data) != TYPE_DICTIONARY:
		return false
	chapter = int(data.get("chapter", 1))
	clues = (data.get("clues", []) as Array)
	flags = (data.get("flags", {}) as Dictionary)
	met_chars = (data.get("met_chars", []) as Array)
	# Salvaguarda: descarta claves de personaje que ya no existan (saves antiguos),
	# para que el tablero dinámico nunca reciba una clave inválida.
	met_chars = met_chars.filter(func(k): return Story.CHARS.has(String(k)))
	return true


func delete_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)


func _ready() -> void:
	_register_input_actions()
	_build_fade_layer()
	_build_sfx()
	font_title = load(FONT_TITLE_PATH)
	font_accent = load(FONT_ACCENT_PATH)
	_setup_cjk_fallback()
	settings["language"] = _detect_language()   # defecto: idioma del dispositivo (o inglés)
	_load_settings()                            # si el usuario ya eligió, prevalece lo guardado
	_load_translations()
	_apply_settings()


## Idioma inicial según el dispositivo: es / zh si coinciden (cualquier variante),
## en para todo lo demás. El usuario puede cambiarlo luego en Opciones.
func _detect_language() -> String:
	var loc := OS.get_locale().to_lower()   # p.ej. "es_es", "es_mx", "zh_cn", "zh_tw", "en_us", "fr_fr"
	if loc.begins_with("es"):
		return "es"   # español cubre todas sus variantes
	if loc.begins_with("zh"):
		return "zh"   # chino cubre todas sus variantes
	return "en"       # cualquier otro idioma -> inglés


## Las fuentes Kenney son latinas; para que el chino (u otros glifos) se vea, se
## añade una fuente del sistema CJK como respaldo a las fuentes y a la de por defecto.
func _setup_cjk_fallback() -> void:
	var cjk := SystemFont.new()
	cjk.font_names = PackedStringArray(["Microsoft YaHei UI", "Microsoft YaHei", "SimHei",
		"Noto Sans CJK SC", "Noto Sans SC", "PingFang SC", "sans-serif"])
	for f in [font_title, font_accent, load(FONT_BODY_PATH)]:
		if f is FontFile:
			var fl: Array = (f as FontFile).fallbacks
			fl.append(cjk)
			(f as FontFile).fallbacks = fl


# --- Estilos de texto (iconografia tipografica) ---
func style_main_title(l: Label, size: int) -> void:
	l.add_theme_font_override("font", font_title)
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", COL_TEXT)

func style_subtitle(l: Label, size: int) -> void:
	l.add_theme_font_override("font", font_title)
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", COL_ACCENT)

func style_tagline(l: Label, size: int) -> void:
	l.add_theme_font_override("font", font_accent)
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", COL_TEXT_MUTED)

func style_dialogue(l: Label, size: int) -> void:
	l.add_theme_font_size_override("font_size", size)      # cuerpo por defecto
	l.add_theme_color_override("font_color", COL_TEXT)


## Pool de reproductores para solapar efectos sin cortarlos.
func _build_sfx() -> void:
	for i in 6:
		var p := AudioStreamPlayer.new()
		add_child(p)
		_sfx_pool.append(p)


func play_sfx(path: String, volume_db: float = 0.0) -> void:
	if path.is_empty():
		return
	var stream = load(path)
	if stream == null:
		return
	var p: AudioStreamPlayer = _sfx_pool[_sfx_idx]
	_sfx_idx = (_sfx_idx + 1) % _sfx_pool.size()
	p.stream = stream
	p.volume_db = volume_db
	p.play()


func play_footstep() -> void:
	play_sfx(SFX_FOOTSTEP % (randi() % 10), -7.0)




## Registra acciones en runtime para no depender de la serializacion del
## project.godot y garantizar el mismo control en Windows y Android.
func _register_input_actions() -> void:
	var actions := {
		"move_up": [KEY_W, KEY_UP],
		"move_down": [KEY_S, KEY_DOWN],
		"move_left": [KEY_A, KEY_LEFT],
		"move_right": [KEY_D, KEY_RIGHT],
		"interact": [KEY_E, KEY_SPACE],
		"attack": [KEY_J],
		"pause": [KEY_ESCAPE],
		"notebook": [KEY_N, KEY_TAB],
	}
	for act in actions.keys():
		if not InputMap.has_action(act):
			InputMap.add_action(act)
		for key in actions[act]:
			var ev := InputEventKey.new()
			ev.physical_keycode = key
			InputMap.action_add_event(act, ev)


func _build_fade_layer() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 128
	add_child(layer)
	_fade = ColorRect.new()
	_fade.color = Color(0, 0, 0, 0)
	_fade.set_anchors_preset(Control.PRESET_FULL_RECT)
	_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(_fade)


## Cambia de escena con un fundido a negro suave.
func change_scene(path: String, fade_time: float = 0.45) -> void:
	var t := create_tween()
	t.tween_property(_fade, "color:a", 1.0, fade_time)
	await t.finished
	get_tree().change_scene_to_file(path)
	var t2 := create_tween()
	t2.tween_property(_fade, "color:a", 0.0, fade_time)


func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)


# --- Ajustes ---
func _load_settings() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SETTINGS_PATH) != OK:
		return
	for key in settings.keys():
		settings[key] = cfg.get_value("game", key, settings[key])


func save_settings() -> void:
	var cfg := ConfigFile.new()
	for key in settings.keys():
		cfg.set_value("game", key, settings[key])
	cfg.save(SETTINGS_PATH)


func _apply_settings() -> void:
	var v: float = clamp(float(settings["master_volume"]), 0.0, 1.0)
	AudioServer.set_bus_mute(0, v <= 0.001)
	AudioServer.set_bus_volume_db(0, linear_to_db(max(v, 0.0001)))
	var mode := DisplayServer.WINDOW_MODE_FULLSCREEN if settings["fullscreen"] \
		else DisplayServer.WINDOW_MODE_WINDOWED
	# En movil siempre pantalla completa; solo tocamos el modo en escritorio.
	if OS.get_name() in ["Windows", "Linux", "macOS"]:
		DisplayServer.window_set_mode(mode)


func set_setting(key: String, value) -> void:
	settings[key] = value
	_apply_settings()
	save_settings()
