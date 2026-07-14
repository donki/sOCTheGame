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
# en tablas cargadas de assets/i18n/. Si falta, cae a español. Idiomas: es/en/zh.
const LANGUAGES := ["es", "en", "zh"]
const LANG_NAMES := {"es": "Español", "en": "English", "zh": "简体中文"}
# Banderas del selector de idioma (imagenes; los emoji de bandera no se renderizan
# como banderas en Windows/Godot). Dominio publico (banderas nacionales) -> ADR-040.
const LANG_FLAGS := {
	"es": "res://assets/ui/flag_es.png",
	"en": "res://assets/ui/flag_en.png",
	"zh": "res://assets/ui/flag_zh.png",
}
var _tr := {"en": {}, "zh": {}}   # lang -> {texto_es: traducción}

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
	for lang in ["en", "zh"]:
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

# --- Voice blips (voz estilizada por personaje, generativa, sin ficheros) ---
# Cada personaje tiene una VOZ distinta: no solo tono, sino timbre propio (color
# vocal por formante, cantidad de zumbido y velocidad de caída). Se sintetiza un
# WAV por personaje la primera vez y se cachea.
var _voice_pool: Array = []
var _voice_idx := 0
var _voice_cache: Dictionary = {}
var voices_enabled := true

# --- TTS real (voces del sistema: Windows SAPI / Android TTS) ---
# Si hay TTS disponible, las líneas de diálogo se LEEN con una voz distinta por
# personaje (voz del sistema por género + tono + velocidad propios). Reemplaza a los blips.
var tts_available := false
var _tts_all: Array = []         # todas las voces disponibles (fallback)
var _tts_male: Array = []        # voces masculinas (español si las hay)
var _tts_female: Array = []      # voces femeninas
# Personajes con voz femenina (el resto = masculina). El tono fino lo da VOICE_PITCH.
const VOICE_FEMALE := ["detective", "rosa", "carmen", "marta", "laura", "clara", "sonia",
	"adler", "madame", "periodista", "testigo", "anonimo"]
# Tono base por personaje (1.0 = timbre base ~1150 Hz). Graves los hombres mayores,
# agudos las voces jóvenes/femeninas. Los que falten usan un tono estable por hash.
const VOICE_PITCH := {
	"detective": 1.14, "nunez": 0.72, "diego": 1.02, "clara": 1.22, "sonia": 1.30,
	"periodista": 1.18, "ruben": 0.66, "marco": 0.90, "adler": 1.08, "testigo": 1.30,
	"kessler": 0.86, "comisario": 0.80, "magnate": 0.74, "vidal": 0.84, "emilio": 0.80,
	"rosa": 1.26, "tomas": 0.88, "carmen": 1.00, "marta": 1.24, "laura": 1.20,
	"padre": 0.82, "nano": 0.92, "corredor": 0.86, "madame": 1.05, "chivato": 1.00,
	"voluntario": 0.95, "contable": 0.90, "anonimo": 0.96, "encapuchado": 0.68, "sospechoso": 0.88,
}

# --- Caso / libreta de pistas ---
var chapter: int = 1       # capítulo actual (1..3)
var clues: Array = []      # [{title, text}]
var flags: Dictionary = {} # banderas de progreso (done_emilio, cap1_completo, ...)
var met_chars: Array = []  # claves CHARS de personajes conocidos (para el tablero dinámico)

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
	_build_voice()
	_init_tts()
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


# --- VOICE BLIPS -----------------------------------------------------------
## Voz estilizada por personaje (estilo Ace Attorney/Undertale, sin TTS ni ficheros):
## se reproduce un blip corto por cada pocos caracteres al escribir el diálogo. Cada
## personaje suena DISTINTO porque su blip se sintetiza con parámetros propios
## (tono base, color vocal por formante, zumbido y caída). El narrador no lleva voz.
func _build_voice() -> void:
	for i in 5:
		var p := AudioStreamPlayer.new()
		add_child(p)
		_voice_pool.append(p)


func _voice_pitch(who: String) -> float:
	if VOICE_PITCH.has(who):
		return VOICE_PITCH[who]
	return 0.80 + float(abs(who.hash()) % 60) / 100.0       # 0.80..1.39 estable por personaje


# Vocales por formantes (F1,F2 en Hz). Cada personaje habla en una vocal distinta.
const VOWELS := [
	[720.0, 1240.0],   # /a/
	[530.0, 1840.0],   # /e/
	[390.0, 2300.0],   # /i/
	[490.0, 900.0],    # /o/
	[350.0, 760.0],    # /u/
	[620.0, 1500.0],   # /ae/
]

## Parámetros de voz por personaje: [f0 Hz (fundamental GRAVE de voz), F1, F2, caída, glissando].
## f0 sale del tono curado (VOICE_PITCH) mapeado a rango de voz humana; la vocal y el resto,
## estables por el nombre. La clave para que suene a voz (no a pitido) es f0 bajo + formantes.
func _voice_params(who: String) -> Array:
	var f0: float = clampf(150.0 * _voice_pitch(who), 82.0, 245.0)   # ~100 (hombre) .. 240 (mujer)
	var h: int = abs(who.hash())
	var v: Array = VOWELS[h % VOWELS.size()]
	var decay: float = 13.0 + float((h / 6) % 5) * 2.4               # 13..23 (sílaba corta)
	var glide: float = (float((h / 30) % 5) - 2.0) * 0.05            # -0.10..+0.10 (entonación)
	return [f0, v[0], v[1], decay, glide]


## Sintetiza (y cachea) el blip de un personaje por FORMANTES: fuente glótica (diente de
## sierra rica en armónicos) a f0 grave, filtrada por dos resonadores (F1, F2) que dan el
## color de vocal, con ataque suave, caída y un leve glissando. Suena a sílaba, no a pitido.
func _blip_for(who: String) -> AudioStreamWAV:
	if _voice_cache.has(who):
		return _voice_cache[who]
	var pr := _voice_params(who)
	var f0: float = pr[0]; var f1: float = pr[1]; var f2: float = pr[2]
	var decay: float = pr[3]; var glide: float = pr[4]
	var rate := 22050
	var dur := 0.11
	var n := int(dur * rate)
	# Resonadores de 2 polos (uno por formante). r cerca de 1 = resonancia estrecha.
	var r1: float = exp(-PI * 110.0 / rate); var c1: float = 2.0 * r1 * cos(TAU * f1 / rate)
	var r2: float = exp(-PI * 130.0 / rate); var c2: float = 2.0 * r2 * cos(TAU * f2 / rate)
	var y1a := 0.0; var y1b := 0.0; var y2a := 0.0; var y2b := 0.0
	var phase := 0.0
	var data := PackedByteArray()
	data.resize(n * 2)
	for i in n:
		var t := float(i) / rate
		var f := f0 * (1.0 + glide * (t / dur))          # entonación (glissando)
		phase += f / rate
		if phase >= 1.0:
			phase -= 1.0
		var src: float = 2.0 * phase - 1.0               # diente de sierra (glotis)
		# F1
		var o1: float = (1.0 - r1) * src + c1 * y1a - r1 * r1 * y1b
		y1b = y1a; y1a = o1
		# F2
		var o2: float = (1.0 - r2) * src + c2 * y2a - r2 * r2 * y2b
		y2b = y2a; y2a = o2
		var env: float = minf(1.0, t / 0.008) * exp(-t * decay)   # ataque 8ms + caída
		var val: float = (0.85 * o1 + 0.55 * o2 + 0.10 * src) * env * 0.9
		data.encode_s16(i * 2, int(clampf(val, -1.0, 1.0) * 32767.0))
	var wav := AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = rate
	wav.stereo = false
	wav.data = data
	_voice_cache[who] = wav
	return wav


func play_voice(who: String) -> void:
	if not voices_enabled or who == "" or who == "narrador" or _voice_pool.is_empty():
		return
	var p: AudioStreamPlayer = _voice_pool[_voice_idx]
	_voice_idx = (_voice_idx + 1) % _voice_pool.size()
	p.stream = _blip_for(who)
	p.pitch_scale = 1.0 + randf_range(-0.04, 0.04)          # micro-variación viva
	p.volume_db = -13.0
	p.play()


# --- TTS ---------------------------------------------------------------------
## Detecta el TTS del sistema y clasifica las voces por género (español preferente).
func _init_tts() -> void:
	if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
		return
	var voices: Array = DisplayServer.tts_get_voices()      # [{id,name,language}, ...]
	var fem_markers := ["helena", "laura", "zira", "sabina", "hazel", "eva", "elvira", "maria", "paulina", "monica"]
	var es_m: Array = []; var es_f: Array = []; var any_m: Array = []; var any_f: Array = []
	for v in voices:
		var id := String((v as Dictionary).get("id", ""))
		if id == "":
			continue
		_tts_all.append(id)
		var nm := String((v as Dictionary).get("name", "")).to_lower()
		var female := false
		for m in fem_markers:
			if nm.contains(m):
				female = true
				break
		var es := String((v as Dictionary).get("language", "")).to_lower().begins_with("es")
		if female:
			any_f.append(id)
			if es: es_f.append(id)
		else:
			any_m.append(id)
			if es: es_m.append(id)
	# Preferir voces en español si hay alguna.
	if not es_m.is_empty() or not es_f.is_empty():
		_tts_male = es_m; _tts_female = es_f
	else:
		_tts_male = any_m; _tts_female = any_f
	tts_available = not _tts_all.is_empty()


## Voz TTS por personaje: [voice_id, tono, velocidad]. Elige voz por GÉNERO (set
## VOICE_FEMALE + tono), y varía tono/velocidad de forma estable por el nombre.
func _tts_voice_for(who: String) -> Array:
	var h: int = abs(who.hash())
	var female: bool = who in VOICE_FEMALE or _voice_pitch(who) >= 1.18
	var pool: Array = _tts_female if female else _tts_male
	if pool.is_empty():
		pool = _tts_male if not _tts_male.is_empty() else _tts_female
	if pool.is_empty():
		pool = _tts_all
	var voice: String = pool[h % pool.size()] if not pool.is_empty() else ""
	var pitch: float = clampf(_voice_pitch(who), 0.6, 1.8)
	var rate: float = 0.90 + float((h / 7) % 6) * 0.05      # 0.90..1.15 velocidad propia
	return [voice, pitch, rate]


## Lee una línea con la voz del personaje (corta la anterior). El narrador no se lee.
func speak_line(who: String, text: String) -> void:
	if not tts_available or not voices_enabled or who == "" or who == "narrador":
		return
	if text.strip_edges() == "":
		return
	var vp := _tts_voice_for(who)
	DisplayServer.tts_speak(text, String(vp[0]), 60, float(vp[1]), float(vp[2]), 0, true)


func stop_speaking() -> void:
	if tts_available:
		DisplayServer.tts_stop()


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
