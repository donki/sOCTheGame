extends Control
class_name DialogueView
## Reproductor de dialogos estilo NOVELA VISUAL.
## Se instancia como capa sobre el mapa (CityMap lo añade como hijo), reproduce
## un dialogo (ver formato en Story.gd) y emite `finished` al terminar.
##
## Uso:
##   var dv := DialogueView.new()
##   add_child(dv)
##   dv.finished.connect(_on_dialogue_finished)
##   dv.start(Story.get_dialogue("emilio"))

signal finished(result: Dictionary)

const TYPE_CPS := 48.0        # caracteres por segundo del efecto maquina de escribir
const PORTRAIT_H := 0.82      # alto del retrato como fraccion de la pantalla
const CLUE_CARD := Vector2(300, 344)   # polaroid del destello de prueba descubierta
const CLUE_HOLD := 1.1        # segundos que se sostiene la foto antes de irse

var _queue: Array = []
var _dialogue: Dictionary = {}
var _left_key := ""
var _right_key := ""
var _active_side := "left"
var _choosing := false

# Efecto de escritura
var _typing := false
var _full := ""
var _typed := 0.0   # progreso fraccional (evita perder decimales al truncar)
var _who := "narrador"   # hablante actual

# Nodos
var _bg: TextureRect
var _bg_grad: ColorRect
var _bg_caption: Label
var _portrait_l: Panel      # marco (foto de expediente) con el retrato recortado dentro
var _portrait_r: Panel

# Retrato "vivo": el hablante respira (scale sutil), balancea algo más al hablar
# (typewriter) y parpadea de vez en cuando. El que no habla ya se atenúa (_dim_portrait).
var _active_frame: Panel = null
var _live_t := 0.0
var _blink_t := 3.0
var _blink := 0.0
var _box: Panel
var _nameplate: Panel
var _name_label: Label
var _text: Label
var _hint: Label
var _choices: VBoxContainer
var _skip_btn: Button        # "Saltar ⏭": solo en revisitas (escena ya vista)

var _is_repeat := false      # true si esta escena ya se había completado antes

var _placeholder_cache: Dictionary = {}


func _ready() -> void:
	# IMPORTANTE: anchors + OFFSETS. Con solo set_anchors_preset el Control se queda
	# a tamaño 0 (offsets sin fijar) y la caja de diálogo colapsa -> el texto se
	# apila en vertical a la izquierda. set_anchors_and_offsets_preset lo rellena.
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	_build_ui()


func start(dialogue: Dictionary) -> void:
	_dialogue = dialogue
	_queue = (dialogue.get("beats", []) as Array).duplicate()
	# Revisita: si el done_<id> de esta escena YA estaba puesto al empezar, no es la
	# primera vez -> ofrecemos "Saltar ⏭" para pasar la narración hasta las acciones.
	var flag := String(dialogue.get("flag", ""))
	_is_repeat = flag != "" and Global.has_flag(flag)
	if _is_repeat:
		_build_skip_button()
	_apply_bg(dialogue.get("bg", ""))
	# Aparicion suave
	modulate.a = 0.0
	var t := create_tween()
	t.tween_property(self, "modulate:a", 1.0, 0.35)
	_advance()


## Botón discreto (arriba-derecha) para saltar la narración ya vista. Se detiene en la
## primera decisión (choices) para que el jugador siga tomando las acciones; si no hay
## decisiones, salta hasta el final de la escena.
func _build_skip_button() -> void:
	_skip_btn = Button.new()
	_skip_btn.text = Global.loc("Saltar ⏭")
	_skip_btn.focus_mode = Control.FOCUS_NONE
	_skip_btn.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_skip_btn.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	_skip_btn.offset_left = -150
	_skip_btn.offset_right = -18
	_skip_btn.offset_top = 16
	_skip_btn.offset_bottom = 52
	_skip_btn.add_theme_font_size_override("font_size", 14)
	_skip_btn.add_theme_color_override("font_color", Global.COL_TEXT)
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.08, 0.09, 0.12, 0.86)
	sb.set_corner_radius_all(6)
	sb.set_border_width_all(1)
	sb.border_color = Global.COL_ACCENT_DIM
	sb.set_content_margin_all(8)
	_skip_btn.add_theme_stylebox_override("normal", sb)
	var hb := sb.duplicate() as StyleBoxFlat
	hb.border_color = Global.COL_ACCENT
	_skip_btn.add_theme_stylebox_override("hover", hb)
	_skip_btn.pressed.connect(_skip_to_actions)
	add_child(_skip_btn)


func _skip_to_actions() -> void:
	if _choosing:
		return
	Global.play_sfx(Global.SFX_CLICK, -6.0)
	_typing = false
	# Descarta los beats de narración hasta topar con una decisión (choices) o el final.
	while not _queue.is_empty() and not (_queue[0] as Dictionary).has("choices"):
		var beat: Dictionary = _queue.pop_front()
		if beat.has("bg"):
			_apply_bg(beat.bg)
	_advance()   # muestra la decisión, o si la cola quedó vacía cierra la escena


# ---------------------------------------------------------------------------
#  CONSTRUCCION DE LA UI
# ---------------------------------------------------------------------------
func _build_ui() -> void:
	# Fondo: gradiente de respaldo + imagen (si existe) + rotulo de localizacion
	_bg_grad = ColorRect.new()
	_bg_grad.set_anchors_preset(Control.PRESET_FULL_RECT)
	_bg_grad.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sh := Shader.new()
	sh.code = """
shader_type canvas_item;
uniform vec4 top : source_color = vec4(0.09, 0.10, 0.15, 1.0);
uniform vec4 bot : source_color = vec4(0.02, 0.03, 0.05, 1.0);
void fragment() {
	vec3 c = mix(top.rgb, bot.rgb, UV.y);
	float vig = smoothstep(1.05, 0.35, length(UV - 0.5));
	c *= mix(0.45, 1.0, vig);
	COLOR = vec4(c, 1.0);
}
"""
	var mat := ShaderMaterial.new()
	mat.shader = sh
	_bg_grad.material = mat
	add_child(_bg_grad)

	_bg = TextureRect.new()
	_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	_bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_bg)

	# Marco cinematografico: vineta negra que se funde a la imagen (textura, fiable).
	var _mfrm := TextureRect.new()
	_mfrm.set_anchors_preset(Control.PRESET_FULL_RECT)
	_mfrm.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_mfrm.stretch_mode = TextureRect.STRETCH_SCALE
	if ResourceLoader.exists("res://assets/ui/frame_vignette.png"):
		_mfrm.texture = load("res://assets/ui/frame_vignette.png")
	add_child(_mfrm)

	# Oscurecido inferior para legibilidad del texto
	var scrim := ColorRect.new()
	scrim.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	scrim.offset_top = -260
	scrim.color = Color(0, 0, 0, 0)
	scrim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sh2 := Shader.new()
	sh2.code = """
shader_type canvas_item;
void fragment() { COLOR = vec4(0.0, 0.0, 0.0, UV.y * 0.75); }
"""
	var m2 := ShaderMaterial.new()
	m2.shader = sh2
	scrim.material = m2
	add_child(scrim)

	_bg_caption = Label.new()
	_bg_caption.set_anchors_preset(Control.PRESET_CENTER_TOP)
	_bg_caption.anchor_left = 0.5
	_bg_caption.anchor_right = 0.5
	_bg_caption.offset_top = 24
	_bg_caption.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_bg_caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_bg_caption.mouse_filter = Control.MOUSE_FILTER_IGNORE
	Global.style_tagline(_bg_caption, 20)
	add_child(_bg_caption)

	# Retratos
	_portrait_l = _make_portrait(true)
	add_child(_portrait_l)
	_portrait_r = _make_portrait(false)
	add_child(_portrait_r)

	# Caja de dialogo
	_box = Panel.new()
	_box.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	_box.offset_left = 40
	_box.offset_right = -40
	_box.offset_top = -196
	_box.offset_bottom = -24
	var ps := StyleBoxFlat.new()
	ps.bg_color = Color(0.05, 0.06, 0.09, 0.95)
	ps.set_corner_radius_all(10)
	ps.border_width_left = 3
	ps.border_width_top = 1
	ps.border_width_right = 1
	ps.border_width_bottom = 1
	ps.border_color = Global.COL_ACCENT
	ps.set_content_margin_all(20)
	_box.add_theme_stylebox_override("panel", ps)
	add_child(_box)

	_text = Label.new()
	_text.set_anchors_preset(Control.PRESET_FULL_RECT)
	# Padding interno (el Label anclado ignora el content_margin del StyleBox).
	_text.offset_left = 30
	_text.offset_top = 24
	_text.offset_right = -30
	_text.offset_bottom = -14
	_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_text.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	Global.style_dialogue(_text, 20)
	_box.add_child(_text)

	_hint = Label.new()
	_hint.text = Global.loc("▼  [ click / espacio ]")
	_hint.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	_hint.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	_hint.grow_vertical = Control.GROW_DIRECTION_BEGIN
	_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_hint.offset_left = -260
	_hint.offset_right = -12
	_hint.offset_top = -30
	_hint.add_theme_font_size_override("font_size", 13)
	_hint.add_theme_color_override("font_color", Global.COL_TEXT_MUTED)
	_box.add_child(_hint)

	# Placa de nombre (sobre la caja)
	_nameplate = Panel.new()
	_nameplate.position = Vector2(60, 0)   # se recoloca en _place_nameplate
	_nameplate.custom_minimum_size = Vector2(0, 34)
	var nsb := StyleBoxFlat.new()
	nsb.bg_color = Color(0.10, 0.11, 0.15, 0.98)
	nsb.set_corner_radius_all(6)
	nsb.border_width_bottom = 3
	nsb.border_color = Global.COL_ACCENT
	nsb.content_margin_left = 16
	nsb.content_margin_right = 16
	nsb.content_margin_top = 4
	nsb.content_margin_bottom = 4
	_nameplate.add_theme_stylebox_override("panel", nsb)
	add_child(_nameplate)

	_name_label = Label.new()
	_name_label.add_theme_font_override("font", Global.font_body)   # Play (nombres)
	_name_label.add_theme_font_size_override("font_size", 20)
	_nameplate.add_child(_name_label)

	# Botones de eleccion
	_choices = VBoxContainer.new()
	_choices.set_anchors_preset(Control.PRESET_CENTER)
	_choices.anchor_left = 0.5
	_choices.anchor_right = 0.5
	_choices.anchor_top = 0.5
	_choices.anchor_bottom = 0.5
	_choices.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_choices.grow_vertical = Control.GROW_DIRECTION_BOTH
	_choices.add_theme_constant_override("separation", 12)
	_choices.visible = false
	add_child(_choices)


func _make_portrait(is_left: bool) -> Panel:
	# Marco tipo "foto de expediente / holo-ID": panel (360x478) anclado a la esquina
	# inferior izq/dcha, con esquinas redondeadas + borde neon y el retrato recortado
	# dentro (COVERED). Como el arte cyberpunk lleva su propio fondo, se enmarca en
	# vez de recortarse a transparente.
	var frame := Panel.new()
	frame.clip_contents = true
	if is_left:
		frame.anchor_left = 0.0
		frame.anchor_right = 0.0
		frame.offset_left = 24
		frame.offset_right = 384
	else:
		frame.anchor_left = 1.0
		frame.anchor_right = 1.0
		frame.offset_left = -384
		frame.offset_right = -24
	frame.anchor_top = 1.0
	frame.anchor_bottom = 1.0
	frame.offset_top = -628
	frame.offset_bottom = -150
	frame.pivot_offset = Vector2(180, 239)   # centro, para el pop-in y el dim
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	# Panel de respaldo: fondo oscuro + sombra proyectada (sin borde: el marco de
	# cómic se dibuja con overlays por ENCIMA de la imagen, más abajo).
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.02, 0.03, 0.05, 1.0)
	sb.set_corner_radius_all(3)
	sb.set_border_width_all(0)
	sb.shadow_color = Color(0, 0, 0, 0.9)
	sb.shadow_size = 30
	sb.shadow_offset = Vector2(9, 14)
	frame.add_theme_stylebox_override("panel", sb)

	var tex := TextureRect.new()
	tex.set_anchors_preset(Control.PRESET_FULL_RECT)
	tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	tex.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	tex.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.add_child(tex)   # imagen SIN shader (limpia)

	# Degradado inferior dentro del marco para fundir con la caja de dialogo.
	var scrim := ColorRect.new()
	scrim.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	scrim.offset_top = -150
	scrim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var ssh := Shader.new()
	ssh.code = """
shader_type canvas_item;
void fragment() { COLOR = vec4(0.03, 0.04, 0.06, pow(UV.y, 1.5) * 0.9); }
"""
	var smat := ShaderMaterial.new()
	smat.shader = ssh
	scrim.material = smat
	frame.add_child(scrim)

	# --- MARCO DE VIÑETA DE CÓMIC (overlays por encima de la imagen) ---
	# Borde exterior de tinta negra, grueso, esquinas casi rectas.
	var ink := Panel.new()
	ink.set_anchors_preset(Control.PRESET_FULL_RECT)
	ink.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var isb := StyleBoxFlat.new()
	isb.bg_color = Color(0, 0, 0, 0)
	isb.set_corner_radius_all(3)
	isb.set_border_width_all(7)
	isb.border_color = Color(0.05, 0.05, 0.06, 1.0)
	ink.add_theme_stylebox_override("panel", isb)
	frame.add_child(ink)
	# Línea interior crema (papel de cómic), separada del borde negro.
	var line := Panel.new()
	line.set_anchors_preset(Control.PRESET_FULL_RECT)
	line.offset_left = 7
	line.offset_top = 7
	line.offset_right = -7
	line.offset_bottom = -7
	line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var lsb := StyleBoxFlat.new()
	lsb.bg_color = Color(0, 0, 0, 0)
	lsb.set_corner_radius_all(1)
	lsb.set_border_width_all(3)
	lsb.border_color = Color(0.93, 0.90, 0.80, 0.95)
	line.add_theme_stylebox_override("panel", lsb)
	frame.add_child(line)

	frame.set_meta("tex", tex)
	frame.modulate = Color(1, 1, 1, 0)
	return frame


# ---------------------------------------------------------------------------
#  REPRODUCCION DE BEATS
# ---------------------------------------------------------------------------
func _advance() -> void:
	if _queue.is_empty():
		_finish()
		return
	var beat: Dictionary = _queue.pop_front()
	if beat.has("bg"):
		_apply_bg(beat.bg)
	if beat.has("choices"):
		_show_choices(beat.choices)
	else:
		_show_line(beat)


func _show_line(beat: Dictionary) -> void:
	_choosing = false
	var who: String = beat.get("who", "narrador")
	_who = who
	Global.note_char(who)   # tablero dinámico: recuerda a quién hemos visto/interrogado
	var info: Dictionary = Story.CHARS.get(who, Story.CHARS["narrador"])
	var is_narration: bool = who == "narrador" or String(info.name).is_empty()

	# El retrato del turno anterior deja de "respirar" (vuelve a su escala normal).
	_reset_frame_scale(_portrait_l)
	_reset_frame_scale(_portrait_r)
	if is_narration:
		_nameplate.visible = false
		_dim_portrait(_portrait_l, true)
		_dim_portrait(_portrait_r, true)
		_active_frame = null
		_text.add_theme_color_override("font_color", Global.COL_TEXT_MUTED)
	else:
		var side: String = beat.get("side", "right" if who == "detective" else "left")
		_active_side = side
		_set_portrait(side, who)
		_nameplate.visible = true
		_name_label.text = Global.loc(info.name)
		_name_label.add_theme_color_override("font_color", info.color)
		_apply_nameplate_border(info.color)
		_place_nameplate(side)
		_dim_portrait(_portrait_l, side != "left")
		_dim_portrait(_portrait_r, side != "right")
		_active_frame = _portrait_l if side == "left" else _portrait_r
		_text.add_theme_color_override("font_color", Global.COL_TEXT)

	_start_typing(String(beat.get("text", "")))


func _show_choices(choices: Array) -> void:
	_choosing = true
	_hint.visible = false
	for c in _choices.get_children():
		c.queue_free()
	for choice in choices:
		var b := _make_choice_button(Global.loc(String(choice.text)))
		var then: Array = choice.get("then", [])
		b.pressed.connect(func() -> void: _pick_choice(then))
		_choices.add_child(b)
	_choices.visible = true


func _pick_choice(then: Array) -> void:
	Global.play_sfx(Global.SFX_CLICK, -4.0)
	_choices.visible = false
	# Insertamos las respuestas al principio de la cola y seguimos
	var merged := then.duplicate()
	merged.append_array(_queue)
	_queue = merged
	_choosing = false
	_hint.visible = true
	_advance()


func _make_choice_button(text: String) -> Button:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = Vector2(560, 46)
	b.add_theme_font_size_override("font_size", 18)
	b.add_theme_color_override("font_color", Global.COL_TEXT)
	b.add_theme_color_override("font_hover_color", Color(1, 1, 1))
	b.add_theme_color_override("font_focus_color", Color(1, 1, 1))
	var mk := func(active: bool) -> StyleBoxFlat:
		var sb := StyleBoxFlat.new()
		sb.bg_color = Color(0.14, 0.09, 0.10, 0.96) if active else Color(0.06, 0.07, 0.10, 0.94)
		sb.set_corner_radius_all(8)
		sb.border_width_left = 3
		sb.border_color = Global.COL_ACCENT if active else Global.COL_ACCENT_DIM
		sb.set_content_margin_all(12)
		return sb
	b.add_theme_stylebox_override("normal", mk.call(false))
	b.add_theme_stylebox_override("hover", mk.call(true))
	b.add_theme_stylebox_override("focus", mk.call(true))
	b.add_theme_stylebox_override("pressed", mk.call(true))
	return b


# ---------------------------------------------------------------------------
#  EFECTO MAQUINA DE ESCRIBIR
# ---------------------------------------------------------------------------
func _start_typing(text: String) -> void:
	_full = Global.loc(text)
	_text.text = _full
	_text.visible_characters = 0
	_typed = 0.0
	_typing = true
	_hint.visible = false
	Global.play_sfx(Global.SFX_NOTE, -8.0)


func _process(delta: float) -> void:
	_live_t += delta
	_update_live_portrait(delta)
	if _typing:
		_typed += TYPE_CPS * delta
		if _typed >= _full.length():
			_text.visible_characters = -1
			_typing = false
			_hint.visible = not _choosing
		else:
			_text.visible_characters = int(_typed)


func _finish_typing() -> void:
	_text.visible_characters = -1
	_typing = false
	_hint.visible = not _choosing


# ---------------------------------------------------------------------------
#  ENTRADA
# ---------------------------------------------------------------------------
## Ratón / táctil: se captura en _input (antes que el GUI) para que el clic avance
## AUNQUE caiga sobre la caja de diálogo u otro hijo con mouse_filter=STOP. Durante
## las elecciones NO se consume, para que los botones de opción sigan funcionando.
func _input(event: InputEvent) -> void:
	if _choosing:
		return
	# No robar el clic/toque que cae sobre el botón "Saltar ⏭" (debe llegar al botón).
	if _skip_btn != null and _skip_btn.visible \
			and (event is InputEventMouseButton or event is InputEventScreenTouch):
		var p: Vector2 = (event as InputEventMouseButton).position if event is InputEventMouseButton \
			else (event as InputEventScreenTouch).position
		if _skip_btn.get_global_rect().has_point(p):
			return
	if (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT) \
			or (event is InputEventScreenTouch and event.pressed):
		get_viewport().set_input_as_handled()
		_tap_advance()


## Teclado: llega por _unhandled_input (ESC lo gestiona el mapa).
func _unhandled_input(event: InputEvent) -> void:
	if _choosing:
		return
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			return
		get_viewport().set_input_as_handled()
		_tap_advance()


func _tap_advance() -> void:
	if _typing:
		_finish_typing()
	else:
		_advance()


# ---------------------------------------------------------------------------
#  RETRATOS
# ---------------------------------------------------------------------------
func _set_portrait(side: String, who: String) -> void:
	var tex := _portrait_texture(who)
	if side == "left":
		if _left_key != who:
			_left_key = who
			(_portrait_l.get_meta("tex") as TextureRect).texture = tex
			_pop_in(_portrait_l)
	else:
		if _right_key != who:
			_right_key = who
			(_portrait_r.get_meta("tex") as TextureRect).texture = tex
			_pop_in(_portrait_r)


func _pop_in(p: Panel) -> void:
	p.scale = Vector2(0.98, 0.98)
	var t := create_tween().set_parallel(true)
	t.tween_property(p, "scale", Vector2(1, 1), 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


## Devuelve un marco a su escala normal (deja de "respirar").
func _reset_frame_scale(p: Panel) -> void:
	if is_instance_valid(p):
		p.pivot_offset = p.size * 0.5
		p.scale = Vector2.ONE


## Da vida al retrato del hablante: respiración lenta (scale sutil), balanceo algo
## más marcado mientras teclea (habla) y un parpadeo/pestañeo ocasional. No mueve la
## boca (encaja con el arte estático); el que no habla ya queda atenuado.
func _update_live_portrait(delta: float) -> void:
	if _active_frame == null or not is_instance_valid(_active_frame):
		return
	if (_active_frame.get_meta("tex") as TextureRect).texture == null:
		return
	_active_frame.pivot_offset = _active_frame.size * 0.5
	var freq := 7.5 if _typing else 1.7      # al hablar respira/balancea más rápido
	var amp := 0.018 if _typing else 0.011
	var breath := 1.0 + amp * sin(_live_t * freq)
	# Parpadeo: compresión vertical rápida cada pocos segundos.
	_blink_t -= delta
	if _blink_t <= 0.0:
		_blink_t = randf_range(2.6, 5.6)
		_blink = 1.0
	if _blink > 0.0:
		_blink = maxf(0.0, _blink - delta * 7.0)
	var squash := 1.0 - 0.05 * _blink
	_active_frame.scale = Vector2(breath, breath * squash)


func _dim_portrait(p: Panel, dim: bool) -> void:
	if (p.get_meta("tex") as TextureRect).texture == null:
		p.modulate = Color(1, 1, 1, 0)
		return
	var target := Color(0.45, 0.47, 0.55, 1.0) if dim else Color(1, 1, 1, 1)
	var t := create_tween()
	t.tween_property(p, "modulate", target, 0.2)


func _portrait_texture(who: String) -> Texture2D:
	var info: Dictionary = Story.CHARS.get(who, {})
	var path: String = info.get("portrait", "")
	if not path.is_empty() and ResourceLoader.exists(path):
		return load(path)
	return _placeholder(who, info.get("color", Color(0.4, 0.4, 0.45)))


## Silueta de respaldo si aun no existe el retrato definitivo.
func _placeholder(who: String, color: Color) -> Texture2D:
	if _placeholder_cache.has(who):
		return _placeholder_cache[who]
	var w := 300
	var h := 420
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	# Cuerpo (hombros)
	for y in range(int(h * 0.62), h):
		for x in w:
			var dx := absf(x - w * 0.5) / (w * 0.5)
			if dx < 0.9 - (y - h * 0.62) / float(h) * 0.2:
				img.set_pixel(x, y, _shade(color, x, y, w, h))
	# Cabeza
	var cx := w * 0.5
	var cy := h * 0.36
	var rx := w * 0.24
	var ry := h * 0.22
	for y in h:
		for x in w:
			var nx := (x - cx) / rx
			var ny := (y - cy) / ry
			if nx * nx + ny * ny < 1.0:
				img.set_pixel(x, y, _shade(color, x, y, w, h))
	var tex := ImageTexture.create_from_image(img)
	_placeholder_cache[who] = tex
	return tex


func _shade(base: Color, x: int, y: int, w: int, h: int) -> Color:
	var v: float = 0.55 + 0.45 * (1.0 - y / float(h)) - 0.15 * absf(x - w * 0.5) / (w * 0.5)
	return Color(base.r * v, base.g * v, base.b * v, 1.0)


# ---------------------------------------------------------------------------
#  FONDO
# ---------------------------------------------------------------------------
func _apply_bg(key: String) -> void:
	if key.is_empty():
		return
	var path: String = Story.BGS.get(key, "")
	if not path.is_empty() and ResourceLoader.exists(path):
		_bg.texture = load(path)
		_bg.visible = true
		_bg_caption.visible = false
	else:
		_bg.texture = null
		_bg.visible = false
		_bg_caption.text = Global.loc(_bg_title(key))
		_bg_caption.visible = true


func _bg_title(key: String) -> String:
	match key:
		"plaza": return "· Plaza del Barrio Viejo · Medianoche ·"
		"casa_emilio": return "· Casa de Don Emilio ·"
		"iglesia_ext": return "· Iglesia de San José · Exterior ·"
		"iglesia_int": return "· Iglesia de San José · Campanario ·"
		"tienda": return "· Tienda de Tomás ·"
		"casa_carmen": return "· Casa de Doña Carmen ·"
		"comisaria": return "· Comisaría del Barrio Viejo ·"
		"casa_marta": return "· Casa de Marta Soler ·"
		"archivo": return "· Archivo policial · Sótano ·"
		"refugio": return "· Fundación Amparo ·"
		"capilla": return "· Capilla privada del Patronato ·"
		"muelle": return "· Muelle viejo · Noche ·"
		"mansion": return "· Mansión de los Bru ·"
		"sotano": return "· El sótano ·"
		"torre": return "· La torre del reloj · Medianoche ·"
		"almacen": return "· Almacén del muelle ·"
		"redaccion": return "· Redacción del diario ·"
		"subasta": return "· Casa de subastas ·"
		"despacho": return "· Bufete Vaultier ·"
		"azotea": return "· La azotea · Tormenta ·"
		"hospital": return "· Hospital central ·"
		"morgue": return "· Morgue municipal ·"
		"laboratorio": return "· Laboratorio Nyxos ·"
		"clinica": return "· Clínica ·"
		"piso_diego": return "· Piso de Diego ·"
		"oficina": return "· Oficinas de Nyxos ·"
		"planta": return "· Planta de Nyxos ·"
		"consejo": return "· Sala del consejo · Nyxos ·"
		"centro": return "· Centro de negocios ·"
		"barrio_alto": return "· Barrio alto ·"
		"ciudad2": return "· La otra ciudad ·"
		"costa": return "· Pueblo de la costa ·"
		"montana": return "· Pueblo de montaña ·"
		"bar_clara": return "· El bar de Clara ·"
		"bar": return "· El bar del Nano ·"
	return ""


# ---------------------------------------------------------------------------
#  PLACA DE NOMBRE
# ---------------------------------------------------------------------------
func _place_nameplate(side: String) -> void:
	# La caja de dialogo esta anclada abajo (offset_top -196); situamos la placa
	# de nombre justo encima de su borde superior.
	var vp := get_viewport_rect().size
	var y := vp.y - 196 - 30
	var x := 60.0 if side == "left" else vp.x - 260.0
	_nameplate.position = Vector2(x, y)
	_nameplate.reset_size()


func _apply_nameplate_border(color: Color) -> void:
	var sb := _nameplate.get_theme_stylebox("panel") as StyleBoxFlat
	if sb:
		sb.border_color = color


# ---------------------------------------------------------------------------
#  FIN
# ---------------------------------------------------------------------------
func _finish() -> void:
	var result := {"clue": null, "flag": "", "false_count": 0}
	if _dialogue.has("clue"):
		var cl: Dictionary = _dialogue.clue
		if Global.add_clue(cl.title, cl.text, cl.get("false", false)):
			result.clue = cl
			if cl.get("false", false):
				result.false_count += 1
	# Lista de pistas (p.ej. las 5 pistas falsas de un red herring).
	if _dialogue.has("clues"):
		for cl in _dialogue.clues:
			if Global.add_clue(cl.title, cl.text, cl.get("false", false)):
				if cl.get("false", false):
					result.false_count += 1
				elif result.clue == null:
					result.clue = cl
	if _dialogue.has("flag"):
		Global.set_flag(String(_dialogue.flag), true)
		result.flag = _dialogue.flag
	# La prueba se ve un instante ANTES de cerrar la escena: si la pista recién
	# descubierta tiene foto de objeto, se enseña la polaroid. Las falsas no la
	# lucen (se descartan; el mapa ya avisa de ellas).
	if result.clue != null and not (result.clue as Dictionary).get("false", false):
		await _flash_clue_photo(result.clue)
	var t := create_tween()
	t.tween_property(self, "modulate:a", 0.0, 0.3)
	await t.finished
	finished.emit(result)
	queue_free()


## Destello de la prueba descubierta: la polaroid entra creciendo sobre la escena
## atenuada, se sostiene un momento y se va. Si la pista no tiene foto (concepto
## abstracto, deducción...) no hace nada y la escena cierra como siempre.
func _flash_clue_photo(clue: Dictionary) -> void:
	var path := Global.clue_image(String(clue.get("title", "")))
	if path == "":
		return
	var tex: Texture2D = load(path)
	if tex == null:
		return

	var layer := Control.new()
	layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.z_index = 200
	add_child(layer)

	var dim := ColorRect.new()
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.color = Color(0, 0, 0, 0.6)
	dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(dim)

	var card := Panel.new()
	card.size = CLUE_CARD
	# Centrada en horizontal, pero alta: así no pisa el cuadro de diálogo de abajo.
	var vp := get_viewport_rect().size
	card.position = Vector2((vp.x - CLUE_CARD.x) * 0.5, vp.y * 0.40 - CLUE_CARD.y * 0.5)
	card.pivot_offset = CLUE_CARD * 0.5
	card.rotation_degrees = -2.5
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.96, 0.90, 0.78)   # crema de polaroid, como en el tablero
	sb.set_corner_radius_all(3)
	sb.shadow_color = Color(0, 0, 0, 0.7)
	sb.shadow_size = 20
	sb.shadow_offset = Vector2(4, 9)
	card.add_theme_stylebox_override("panel", sb)
	layer.add_child(card)

	var photo := Panel.new()
	photo.clip_contents = true
	photo.position = Vector2(12, 12)
	photo.size = Vector2(CLUE_CARD.x - 24, CLUE_CARD.y - 62)
	photo.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var pbg := StyleBoxFlat.new()
	pbg.bg_color = Color(0.06, 0.06, 0.07)
	photo.add_theme_stylebox_override("panel", pbg)
	card.add_child(photo)

	var img := TextureRect.new()
	img.set_anchors_preset(Control.PRESET_FULL_RECT)
	img.texture = tex
	img.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	img.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	img.mouse_filter = Control.MOUSE_FILTER_IGNORE
	photo.add_child(img)

	var cap := Label.new()
	cap.text = Global.loc(String(clue.get("title", "")))
	cap.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
	cap.clip_text = true
	cap.position = Vector2(10, CLUE_CARD.y - 44)
	cap.size = Vector2(CLUE_CARD.x - 20, 32)
	cap.add_theme_font_size_override("font_size", 18)
	cap.add_theme_color_override("font_color", Color(0.14, 0.11, 0.08))
	cap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(cap)

	layer.modulate.a = 0.0
	card.scale = Vector2(0.86, 0.86)
	Global.play_sfx(Global.SFX_NOTE, -4.0)
	var tin := create_tween()
	tin.set_parallel(true)
	tin.tween_property(layer, "modulate:a", 1.0, 0.22)
	tin.tween_property(card, "scale", Vector2.ONE, 0.3) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await tin.finished
	await get_tree().create_timer(CLUE_HOLD).timeout
	var tout := create_tween()
	tout.tween_property(layer, "modulate:a", 0.0, 0.28)
	await tout.finished
	layer.queue_free()
