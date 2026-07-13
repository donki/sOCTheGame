extends Control
## Pantalla principal de "sOC the Game".
## Construida por codigo para garantizar carga sin errores de formato .tscn.
## Estetica: noche urbana, resplandor rojo (linterna/peligro) y lluvia.

const GAME_SCENE := "res://scenes/CityMap.tscn"
const MIX := 22050.0

var _rain: CPUParticles2D
var _options: Control
var _first_button: Button

# Tormenta (lluvia + rayos + truenos)
var _audio: AudioStreamPlayer
var _flash: ColorRect
var _t := 0.0
var _atime := 0.0
var _next_bolt := 4.0
var _rain_lp := 0.0
var _brown2 := 0.0
var _thunder := []


func _ready() -> void:
	randomize()
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_build_background()
	_build_rain()
	_build_center()
	_build_footer()
	_build_options_overlay()
	_build_storm()
	Music.play_mood("noir")   # música noir bajo la tormenta (autoload persistente)
	get_viewport().size_changed.connect(_on_resized)
	_on_resized()
	if _first_button:
		_first_button.grab_focus()


func _process(delta: float) -> void:
	_t += delta
	_fill_audio()
	if _t >= _next_bolt:
		_next_bolt = _t + randf_range(7.0, 15.0)
		_lightning()


# ---------------------------------------------------------------------------
#  TORMENTA: sonido de lluvia + rayos + truenos (audio sintetizado)
# ---------------------------------------------------------------------------
func _build_storm() -> void:
	_audio = AudioStreamPlayer.new()
	var gen := AudioStreamGenerator.new()
	gen.mix_rate = MIX
	gen.buffer_length = 0.2
	_audio.stream = gen
	_audio.volume_db = 0.0
	add_child(_audio)
	_audio.play()

	var layer := CanvasLayer.new()
	layer.layer = 20
	add_child(layer)
	_flash = ColorRect.new()
	_flash.color = Color(0.85, 0.9, 1.0, 0.0)
	_flash.set_anchors_preset(Control.PRESET_FULL_RECT)
	_flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(_flash)


func _lightning() -> void:
	var strength := randf_range(0.35, 0.6)
	var tw := create_tween()
	tw.tween_property(_flash, "color:a", strength, 0.06)
	tw.tween_property(_flash, "color:a", 0.0, 0.45)
	get_tree().create_timer(randf_range(0.35, 1.4)).timeout.connect(func():
		_thunder.append({"t0": _atime, "amp": randf_range(1.7, 2.3)}))


func _fill_audio() -> void:
	var pb := _audio.get_stream_playback()
	if pb == null:
		return
	_thunder = _thunder.filter(func(th): return _atime - th.t0 < 3.0)
	var frames: int = pb.get_frames_available()
	for i in frames:
		var s := _next_sample()
		pb.push_frame(Vector2(s, s))


func _next_sample() -> float:
	_atime += 1.0 / MIX
	var white := randf() * 2.0 - 1.0
	# Lluvia: ruido con leve paso bajo + brillo (siseo)
	_rain_lp = _rain_lp * 0.5 + white * 0.5
	var s := _rain_lp * 0.10 + white * 0.045
	# Truenos: rumor grave (ruido muy filtrado, decaimiento largo)
	for th in _thunder:
		var age: float = _atime - th.t0
		var env := exp(-age / 1.7)
		_brown2 = clampf(_brown2 * 0.996 + (randf() * 2.0 - 1.0) * 0.05, -1.0, 1.0)
		s += _brown2 * env * th.amp
		if age < 0.07:   # chasquido/crack inicial del trueno
			s += (randf() * 2.0 - 1.0) * (1.0 - age / 0.07) * th.amp * 0.6
	return clampf(s, -1.0, 1.0)


# ---------------------------------------------------------------------------
#  FONDO (shader canvas: gradiente + resplandor pulsante + vinyeta + grano)
# ---------------------------------------------------------------------------
const MENU_BG := "res://assets/backgrounds/menu.png"

func _build_background() -> void:
	# Fondo por imagen (cyberpunk) si existe, con un scrim oscuro para legibilidad;
	# si no, el gradiente procedural de respaldo.
	if ResourceLoader.exists(MENU_BG):
		var tr := TextureRect.new()
		tr.texture = load(MENU_BG)
		tr.set_anchors_preset(Control.PRESET_FULL_RECT)
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(tr)
		var scrim := ColorRect.new()
		scrim.set_anchors_preset(Control.PRESET_FULL_RECT)
		scrim.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var ssh := Shader.new()
		ssh.code = """
shader_type canvas_item;
void fragment() {
	// Scrim suave: deja ver el skyline arriba, oscurece hacia abajo (versión/pie)
	// y un pelín en los bordes. Legible sin tapar la ciudad.
	float vig = smoothstep(1.25, 0.45, length(UV - 0.5));
	float a = 0.18 + 0.10 * (1.0 - vig) + 0.44 * pow(UV.y, 1.7);
	COLOR = vec4(0.01, 0.02, 0.04, clamp(a, 0.0, 0.8));
}
"""
		var smat := ShaderMaterial.new()
		smat.shader = ssh
		scrim.material = smat
		add_child(scrim)
		return

	var bg := ColorRect.new()
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sh := Shader.new()
	sh.code = """
shader_type canvas_item;
uniform vec4 top_color : source_color = vec4(0.055, 0.070, 0.105, 1.0);
uniform vec4 bottom_color : source_color = vec4(0.010, 0.020, 0.030, 1.0);
uniform vec4 glow_color : source_color = vec4(0.86, 0.20, 0.20, 1.0);

float hash(vec2 p){ return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453); }

void fragment() {
	vec2 uv = UV;
	vec3 col = mix(top_color.rgb, bottom_color.rgb, uv.y);
	vec2 c = uv - vec2(0.5, 0.30);
	c.x *= 1.7;
	float d = length(c);
	float pulse = 0.5 + 0.5 * sin(TIME * 0.8);
	float glow = smoothstep(0.62, 0.0, d) * (0.10 + 0.06 * pulse);
	col += glow_color.rgb * glow;
	float vig = smoothstep(0.95, 0.30, length(UV - 0.5));
	col *= mix(0.30, 1.0, vig);
	col += (hash(UV * 1024.0 + TIME) - 0.5) * 0.02;
	COLOR = vec4(col, 1.0);
}
"""
	var mat := ShaderMaterial.new()
	mat.shader = sh
	bg.material = mat
	add_child(bg)


# ---------------------------------------------------------------------------
#  LLUVIA
# ---------------------------------------------------------------------------
func _build_rain() -> void:
	_rain = CPUParticles2D.new()
	var img := Image.create(2, 13, false, Image.FORMAT_RGBA8)
	img.fill(Color(0.72, 0.82, 1.0, 0.45))
	_rain.texture = ImageTexture.create_from_image(img)
	_rain.amount = 440
	_rain.lifetime = 1.3
	_rain.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	_rain.direction = Vector2(0.2, 1)
	_rain.spread = 5.0
	_rain.gravity = Vector2(160, 1500)
	_rain.initial_velocity_min = 340.0
	_rain.initial_velocity_max = 560.0
	_rain.scale_amount_min = 0.7
	_rain.scale_amount_max = 1.3
	add_child(_rain)


# ---------------------------------------------------------------------------
#  BLOQUE CENTRAL (titulo + botones)
# ---------------------------------------------------------------------------
func _build_center() -> void:
	var center := VBoxContainer.new()
	center.set_anchors_preset(Control.PRESET_CENTER)
	center.anchor_left = 0.5
	center.anchor_right = 0.5
	center.anchor_top = 0.5
	center.anchor_bottom = 0.5
	center.grow_horizontal = Control.GROW_DIRECTION_BOTH
	center.grow_vertical = Control.GROW_DIRECTION_BOTH
	center.alignment = BoxContainer.ALIGNMENT_CENTER
	center.add_theme_constant_override("separation", 10)
	add_child(center)

	# Resplandor tras el titulo (fondo absoluto: no ocupa layout, asi cabe "Salir")
	var glow := TextureRect.new()
	glow.texture = _radial_texture(Global.COL_ACCENT, 0.42)
	glow.set_anchors_preset(Control.PRESET_CENTER)
	glow.anchor_left = 0.5
	glow.anchor_right = 0.5
	glow.anchor_top = 0.5
	glow.anchor_bottom = 0.5
	glow.offset_left = -300
	glow.offset_right = 300
	glow.offset_top = -240
	glow.offset_bottom = 30
	glow.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(glow)
	move_child(glow, center.get_index())
	var tw := create_tween().set_loops()
	tw.tween_property(glow, "modulate:a", 0.55, 1.8).set_trans(Tween.TRANS_SINE)
	tw.tween_property(glow, "modulate:a", 1.0, 1.8).set_trans(Tween.TRANS_SINE)

	# Titulo
	var title := Label.new()
	title.text = "sOC"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	Global.style_main_title(title, 96)
	center.add_child(title)

	var tagline := Label.new()
	tagline.text = Global.loc("La ciudad esconde algo bajo la lluvia.")
	tagline.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	Global.style_tagline(tagline, 20)
	center.add_child(tagline)

	# Separacion antes de los botones
	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 14)
	center.add_child(spacer)

	var buttons := VBoxContainer.new()
	buttons.alignment = BoxContainer.ALIGNMENT_CENTER
	buttons.add_theme_constant_override("separation", 12)
	buttons.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	center.add_child(buttons)

	_first_button = _make_button("Nueva partida", _on_new_game)
	buttons.add_child(_first_button)

	var cont := _make_button("Continuar", _on_continue)
	cont.disabled = not Global.has_save()
	buttons.add_child(cont)

	buttons.add_child(_make_button("Opciones", _on_options))
	buttons.add_child(_make_button("Salir", _on_quit))


func _make_button(text: String, callback: Callable) -> Button:
	var b := Button.new()
	b.text = Global.loc(text)
	b.custom_minimum_size = Vector2(230, 40)
	b.focus_mode = Control.FOCUS_ALL
	b.add_theme_font_size_override("font_size", 17)
	b.add_theme_color_override("font_color", Global.COL_TEXT)
	b.add_theme_color_override("font_hover_color", Color(1, 1, 1))
	b.add_theme_color_override("font_focus_color", Color(1, 1, 1))
	b.add_theme_color_override("font_disabled_color", Color(0.35, 0.37, 0.42))
	b.add_theme_stylebox_override("normal", _button_style(false, false))
	b.add_theme_stylebox_override("hover", _button_style(true, false))
	b.add_theme_stylebox_override("focus", _button_style(true, false))
	b.add_theme_stylebox_override("pressed", _button_style(true, true))
	b.add_theme_stylebox_override("disabled", _button_style(false, false))
	b.pressed.connect(func(): Global.play_sfx(Global.SFX_CLICK, -4.0))
	b.pressed.connect(callback)
	return b


func _button_style(active: bool, pressed: bool) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	if pressed:
		sb.bg_color = Color(0.05, 0.03, 0.04, 0.95)
	elif active:
		sb.bg_color = Color(0.16, 0.09, 0.10, 0.95)
	else:
		sb.bg_color = Color(0.07, 0.08, 0.11, 0.82)
	sb.set_corner_radius_all(6)
	sb.border_width_left = 3
	sb.border_color = Global.COL_ACCENT if active else Global.COL_ACCENT_DIM
	sb.content_margin_left = 22
	sb.content_margin_right = 22
	sb.content_margin_top = 10
	sb.content_margin_bottom = 10
	return sb


# ---------------------------------------------------------------------------
#  PIE
# ---------------------------------------------------------------------------
func _build_footer() -> void:
	var version: String = ProjectSettings.get_setting("application/config/version", "0.1.0")
	var foot := Label.new()
	foot.text = "v%s" % version
	foot.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	foot.offset_top = -24
	foot.offset_left = 14
	foot.add_theme_font_size_override("font_size", 10)
	foot.add_theme_color_override("font_color", Global.COL_TEXT_MUTED)
	add_child(foot)


# ---------------------------------------------------------------------------
#  OPCIONES (overlay)
# ---------------------------------------------------------------------------
func _build_options_overlay() -> void:
	_options = Control.new()
	_options.set_anchors_preset(Control.PRESET_FULL_RECT)
	_options.visible = false
	add_child(_options)

	var dim := ColorRect.new()
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.color = Color(0, 0, 0, 0.6)
	_options.add_child(dim)

	var panel := PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.anchor_left = 0.5
	panel.anchor_right = 0.5
	panel.anchor_top = 0.5
	panel.anchor_bottom = 0.5
	panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	var pstyle := StyleBoxFlat.new()
	pstyle.bg_color = Color(0.06, 0.07, 0.10, 0.98)
	pstyle.set_corner_radius_all(10)
	pstyle.border_width_left = 2
	pstyle.border_width_top = 2
	pstyle.border_width_right = 2
	pstyle.border_width_bottom = 2
	pstyle.border_color = Global.COL_ACCENT_DIM
	pstyle.set_content_margin_all(26)
	panel.add_theme_stylebox_override("panel", pstyle)
	_options.add_child(panel)

	var vb := VBoxContainer.new()
	vb.custom_minimum_size = Vector2(360, 0)
	vb.add_theme_constant_override("separation", 14)
	panel.add_child(vb)

	var head := Label.new()
	head.text = Global.loc("Opciones")
	head.add_theme_font_size_override("font_size", 30)
	head.add_theme_color_override("font_color", Global.COL_TEXT)
	vb.add_child(head)

	vb.add_child(_slider_row("Volumen general", "master_volume"))
	vb.add_child(_slider_row("Musica", "music_volume"))
	vb.add_child(_slider_row("Efectos", "sfx_volume"))

	if OS.get_name() in ["Windows", "Linux", "macOS"]:
		var fs_row := HBoxContainer.new()
		var fs_label := Label.new()
		fs_label.text = Global.loc("Pantalla completa")
		fs_label.add_theme_color_override("font_color", Global.COL_TEXT)
		fs_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		fs_row.add_child(fs_label)
		var fs := CheckButton.new()
		fs.button_pressed = Global.settings["fullscreen"]
		fs.toggled.connect(func(on): Global.set_setting("fullscreen", on))
		fs_row.add_child(fs)
		vb.add_child(fs_row)

	# Selector de idioma (Español / English / 简体中文)
	var lang_row := HBoxContainer.new()
	lang_row.add_theme_constant_override("separation", 8)
	var lang_label := Label.new()
	lang_label.text = Global.loc("Idioma")
	lang_label.custom_minimum_size = Vector2(150, 0)
	lang_label.add_theme_color_override("font_color", Global.COL_TEXT)
	lang_row.add_child(lang_label)
	for code in Global.LANGUAGES:
		var lb := Button.new()
		lb.icon = load(Global.LANG_FLAGS[code])          # bandera en vez del nombre
		lb.expand_icon = true
		lb.custom_minimum_size = Vector2(64, 42)
		lb.tooltip_text = Global.LANG_NAMES[code]         # nombre accesible en el tooltip
		lb.toggle_mode = true
		lb.button_pressed = (Global.language() == code)
		lb.focus_mode = Control.FOCUS_NONE
		lb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		lb.pressed.connect(func(c = code) -> void:
			Global.play_sfx(Global.SFX_CLICK, -5.0)
			Global.set_language(c)
			get_tree().reload_current_scene())
		lang_row.add_child(lb)
	vb.add_child(lang_row)

	var close := _make_button("Volver", _hide_options)
	close.custom_minimum_size = Vector2(0, 46)
	vb.add_child(close)


func _slider_row(label_text: String, key: String) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	var l := Label.new()
	l.text = Global.loc(label_text)
	l.custom_minimum_size = Vector2(150, 0)
	l.add_theme_color_override("font_color", Global.COL_TEXT)
	row.add_child(l)
	var s := HSlider.new()
	s.min_value = 0.0
	s.max_value = 1.0
	s.step = 0.05
	s.value = Global.settings[key]
	s.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	s.value_changed.connect(func(v): Global.set_setting(key, v))
	row.add_child(s)
	return row


# ---------------------------------------------------------------------------
#  ACCIONES
# ---------------------------------------------------------------------------
func _on_new_game() -> void:
	Global.reset_case()
	Global.delete_save()          # partida nueva: empieza de cero
	Global.change_scene(GAME_SCENE)


func _on_continue() -> void:
	Global.load_game()            # recupera pistas y progreso guardados
	Global.change_scene(GAME_SCENE)


func _on_options() -> void:
	_options.visible = true


func _hide_options() -> void:
	_options.visible = false
	if _first_button:
		_first_button.grab_focus()


func _on_quit() -> void:
	get_tree().quit()


func _on_resized() -> void:
	var vp := get_viewport_rect().size
	if _rain:
		_rain.position = Vector2(vp.x * 0.5, -30)
		_rain.emission_rect_extents = Vector2(vp.x * 0.7, 8)


func _radial_texture(col: Color, alpha: float) -> GradientTexture2D:
	var g := Gradient.new()
	g.set_color(0, Color(col.r, col.g, col.b, alpha))
	g.set_color(1, Color(col.r, col.g, col.b, 0.0))
	var gt := GradientTexture2D.new()
	gt.gradient = g
	gt.fill = GradientTexture2D.FILL_RADIAL
	gt.fill_from = Vector2(0.5, 0.5)
	gt.fill_to = Vector2(1.0, 0.5)
	gt.width = 512
	gt.height = 256
	return gt
