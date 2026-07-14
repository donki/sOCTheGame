extends Node2D
## Splash intro cinematica de "sOC the Game".
## Usa la ilustracion pictorica noir de la iglesia (assets/backgrounds/splash.png,
## generada con Pollinations, mismo estilo que el resto de fondos): una noche de
## tormenta con la puerta iluminada como refugio.
## Lluvia, viento, campanas y truenos son audio sintetizado en tiempo real.
## Cierre: resplandor calido en la puerta + campana grave + titulo "sOC the Game"
## y fundido a negro. NO se puede saltar: se reproduce entera y encadena al menu.

const DESIGN := Vector2(1152, 648)
const DURATION := 15.0            # el titulo aparece a ~8s; se mantiene 5s mas antes de fundir
const MIX := 22050.0
const TAU := PI * 2.0

# Sintesis de campana: [ratio_frecuencia, amplitud, decaimiento_seg]
const BELL_PARTIALS := [
	[0.5, 0.28, 3.2], [1.0, 1.0, 2.6], [2.0, 0.6, 1.8], [2.4, 0.5, 1.6],
	[3.0, 0.36, 1.2], [4.2, 0.28, 0.9], [5.4, 0.20, 0.7],
]

var _t := 0.0
var _done := false
var _wind_amp := 0.15
var _bell_times := [1.0, 3.2, 5.2, 6.9, 8.4]
var _light_times := [4.2, 7.4]

var _church: Sprite2D
var _rain: CPUParticles2D
var _flash: ColorRect
var _caption: Label
var _door_light: Sprite2D        # resplandor calido de refugio en la puerta (glow aditivo)
var _title: Label                # titulo del cierre "sOC the Game"
var _endfade: ColorRect          # fundido final a negro
var _deep_done := false          # campana grave de cierre lanzada
var _end_thunder_done := false   # trueno final antes del fundido

# Umbral de la puerta iluminada en assets/backgrounds/splash.png (coord. pantalla,
# imagen 16:9 que cubre 1152x648 sin recorte): la puerta calida esta centrada.
const DOOR := Vector2(576, 384)

# Audio procedural
var _audio: AudioStreamPlayer
var _atime := 0.0
var _brown := 0.0
var _brown2 := 0.0
var _howl_ph := 0.0
var _bell_voices := []
var _thunder := []


func _ready() -> void:
	randomize()
	_build_church()
	_build_door_light()
	_build_rain()
	_build_fx()
	_build_audio()


func _process(delta: float) -> void:
	_t += delta
	_wind_amp = clamp(_t / 5.0, 0.15, 1.0)
	if _rain:
		var gust := 1.0 + 0.35 * sin(_t * 2.3)
		_rain.gravity = Vector2(120 + 420 * _wind_amp * gust, 1500)
		_rain.speed_scale = 0.8 + 0.8 * _wind_amp

	# Zoom cinematico muy lento sobre la ilustracion
	if _church:
		_church.scale = Vector2.ONE * (_cover_scale() * (1.0 + 0.012 * _t))

	# Resplandor de refugio en la puerta: crece con el tiempo, con leve parpadeo
	if _door_light:
		_door_light.modulate.a = clampf(_t / 3.5, 0.0, 0.85) * (0.9 + 0.1 * sin(_t * 5.0))

	while not _bell_times.is_empty() and _t >= _bell_times[0]:
		_bell_times.pop_front()
		_toll()
	while not _light_times.is_empty() and _t >= _light_times[0]:
		_light_times.pop_front()
		_lightning()

	# Leyenda entra ~1s y empieza a salir a ~7.6s (deja paso al titulo)
	var cap_target := 1.0 if (_t > 1.0 and _t < 7.6) else 0.0
	_caption.modulate.a = move_toward(_caption.modulate.a, cap_target, delta * 1.4)

	# --- CIERRE: a ~8s campana grave + ultimo relampago + aparece el titulo;
	#     a ~9.2s fundido a negro que encadena con el menu. ---
	if not _deep_done and _t >= 8.0:
		_deep_done = true
		_toll_deep()
		_lightning()
	if _t >= 8.0:
		_title.modulate.a = move_toward(_title.modulate.a, 1.0, delta * 1.5)
	# Tras mantener el titulo ~5s: relampago + trueno de cierre y fundido a negro.
	if not _end_thunder_done and _t >= 13.9:
		_end_thunder_done = true
		_lightning()
	if _t >= 14.2:
		_endfade.color.a = clampf((_t - 14.2) / 0.8, 0.0, 1.0)

	_fill_audio()

	if _t >= DURATION and not _done:
		_done = true
		Global.change_scene("res://scenes/MainMenu.tscn")


# ---------------------------------------------------------------------------
#  FONDO: ilustracion de la iglesia (proporcional, cubre pantalla)
# ---------------------------------------------------------------------------
func _cover_scale() -> float:
	var tex := _church.texture
	return maxf(DESIGN.x / tex.get_width(), DESIGN.y / tex.get_height())


func _build_church() -> void:
	_church = Sprite2D.new()
	_church.texture = load("res://assets/backgrounds/splash.png")
	_church.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	_church.position = DESIGN * 0.5
	_church.scale = Vector2.ONE * _cover_scale()
	add_child(_church)


func _build_rain() -> void:
	_rain = CPUParticles2D.new()
	var img := Image.create(2, 13, false, Image.FORMAT_RGBA8)
	img.fill(Color(0.75, 0.83, 1.0, 0.42))
	_rain.texture = ImageTexture.create_from_image(img)
	_rain.amount = 300
	_rain.lifetime = 1.4
	_rain.position = Vector2(DESIGN.x * 0.5, -30)
	_rain.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	_rain.emission_rect_extents = Vector2(DESIGN.x * 0.7, 8)
	_rain.direction = Vector2(0.22, 1)
	_rain.spread = 6.0
	_rain.gravity = Vector2(140, 1500)
	_rain.initial_velocity_min = 340.0
	_rain.initial_velocity_max = 560.0
	_rain.scale_amount_min = 0.8
	_rain.scale_amount_max = 1.4
	_rain.z_index = 5
	add_child(_rain)


# ---------------------------------------------------------------------------
#  FX + leyenda (sin rotulo de "saltar": la intro no se puede pasar)
# ---------------------------------------------------------------------------
func _build_fx() -> void:
	var fx := CanvasLayer.new()
	fx.layer = 5
	add_child(fx)

	var vig := TextureRect.new()
	vig.texture = _vignette_texture()
	vig.set_anchors_preset(Control.PRESET_FULL_RECT)
	vig.stretch_mode = TextureRect.STRETCH_SCALE
	vig.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fx.add_child(vig)

	_flash = ColorRect.new()
	_flash.color = Color(0.8, 0.85, 1.0, 0.0)
	_flash.set_anchors_preset(Control.PRESET_FULL_RECT)
	_flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fx.add_child(_flash)

	# Velo oscuro degradado en el tercio inferior: da contraste al texto sobre el
	# fondo anime (el reflejo dorado de la puerta dejaba la frase ilegible).
	var scrim := TextureRect.new()
	var grad := Gradient.new()
	grad.set_color(0, Color(0, 0, 0, 0.0))
	grad.set_color(1, Color(0, 0, 0, 0.75))
	var gtex := GradientTexture2D.new()
	gtex.gradient = grad
	gtex.fill_from = Vector2(0, 0)
	gtex.fill_to = Vector2(0, 1)
	scrim.texture = gtex
	scrim.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	scrim.offset_top = -240
	scrim.offset_bottom = 0
	scrim.stretch_mode = TextureRect.STRETCH_SCALE
	scrim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fx.add_child(scrim)

	_caption = Label.new()
	_caption.text = Global.loc("La ciudad esconde algo bajo la lluvia.")
	_caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_caption.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	_caption.offset_top = -108
	_caption.offset_bottom = -70
	Global.style_tagline(_caption, 34)
	_caption.add_theme_color_override("font_color", Global.COL_WARM)
	_caption.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.95))
	_caption.add_theme_constant_override("outline_size", 6)
	_caption.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.9))
	_caption.add_theme_constant_override("shadow_offset_y", 3)
	_caption.modulate.a = 0.0
	fx.add_child(_caption)

	# Titulo del cierre (aparece a ~8s)
	_title = Label.new()
	_title.text = "sOC"
	_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_title.set_anchors_preset(Control.PRESET_CENTER_TOP)
	_title.anchor_left = 0.0
	_title.anchor_right = 1.0
	_title.offset_top = 244
	_title.offset_bottom = 320
	Global.style_main_title(_title, 66)
	_title.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
	_title.add_theme_constant_override("outline_size", 7)
	_title.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.85))
	_title.add_theme_constant_override("shadow_offset_y", 3)
	_title.modulate.a = 0.0
	fx.add_child(_title)

	# Fundido final a negro (por encima de todo)
	_endfade = ColorRect.new()
	_endfade.color = Color(0, 0, 0, 0.0)
	_endfade.set_anchors_preset(Control.PRESET_FULL_RECT)
	_endfade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fx.add_child(_endfade)


func _build_door_light() -> void:
	# Glow radial ADITIVO (no PointLight2D: en gl_compatibility pintaba un recuadro).
	_door_light = Sprite2D.new()
	_door_light.texture = _radial(420)
	_door_light.position = DOOR
	_door_light.modulate = Color(1.0, 0.78, 0.42, 0.0)   # calido; alpha animado
	_door_light.z_index = 4
	var mat := CanvasItemMaterial.new()
	mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	_door_light.material = mat
	add_child(_door_light)


func _radial(size: int) -> ImageTexture:
	# Radial procedural: RGB de blanco (centro) a NEGRO PURO fuera del circulo.
	# Con blend aditivo, el negro no suma nada -> halo redondo sin recuadro.
	var img := Image.create(size, size, false, Image.FORMAT_RGB8)
	var c := size * 0.5
	for y in size:
		for x in size:
			var d := Vector2(x - c, y - c).length() / c
			var a := clampf(1.0 - d, 0.0, 1.0)
			a = a * a   # falloff suave
			img.set_pixel(x, y, Color(a, a, a))
	return ImageTexture.create_from_image(img)


func _toll_deep() -> void:
	# Campana grave de cierre (frecuencia base mas baja que las normales).
	_bell_voices.append({"t0": _atime, "base": randf_range(96.0, 108.0)})


func _lightning() -> void:
	var strength := randf_range(0.4, 0.65)
	var tw := create_tween()
	tw.tween_property(_flash, "color:a", strength, 0.05)
	tw.tween_property(_flash, "color:a", 0.0, 0.35)
	get_tree().create_timer(randf_range(0.25, 0.6)).timeout.connect(func():
		_thunder.append({"t0": _atime, "amp": randf_range(0.4, 0.6)}))


func _vignette_texture() -> GradientTexture2D:
	var g := Gradient.new()
	g.set_color(0, Color(0, 0, 0, 0))
	g.set_color(1, Color(0, 0, 0, 0.78))
	g.add_point(0.6, Color(0, 0, 0, 0.12))
	var gt := GradientTexture2D.new()
	gt.gradient = g
	gt.fill = GradientTexture2D.FILL_RADIAL
	gt.fill_from = Vector2(0.5, 0.45)
	gt.fill_to = Vector2(1.05, 0.45)
	gt.width = 256
	gt.height = 256
	return gt


# ---------------------------------------------------------------------------
#  AUDIO PROCEDURAL (viento + campanas + truenos)
# ---------------------------------------------------------------------------
func _build_audio() -> void:
	_audio = AudioStreamPlayer.new()
	var gen := AudioStreamGenerator.new()
	gen.mix_rate = MIX
	gen.buffer_length = 0.2
	_audio.stream = gen
	_audio.volume_db = 2.0
	add_child(_audio)
	_audio.play()


func _toll() -> void:
	_bell_voices.append({"t0": _atime, "base": randf_range(158.0, 172.0)})


func _fill_audio() -> void:
	var pb := _audio.get_stream_playback()
	if pb == null:
		return
	_bell_voices = _bell_voices.filter(func(v): return _atime - v.t0 < 4.0)
	_thunder = _thunder.filter(func(th): return _atime - th.t0 < 2.5)
	var frames: int = pb.get_frames_available()
	for i in frames:
		var s := _next_sample()
		pb.push_frame(Vector2(s, s))


func _next_sample() -> float:
	var dt := 1.0 / MIX
	_atime += dt
	var s := 0.0
	var white := randf() * 2.0 - 1.0
	_brown = clampf(_brown * 0.985 + white * 0.06, -1.0, 1.0)
	var gust := 0.6 + 0.4 * sin(_atime * 0.7) + 0.2 * sin(_atime * 2.3)
	var wind := _brown * 2.2 * _wind_amp * gust
	_howl_ph += TAU * (300.0 + 120.0 * sin(_atime * 0.5)) * dt
	wind += sin(_howl_ph) * 0.05 * _wind_amp
	s += wind * 0.45
	for v in _bell_voices:
		s += _bell_sample(v.base, _atime - v.t0) * 0.5
	for th in _thunder:
		var age: float = _atime - th.t0
		var env := exp(-age / 0.8)
		_brown2 = clampf(_brown2 * 0.992 + (randf() * 2.0 - 1.0) * 0.05, -1.0, 1.0)
		s += _brown2 * env * th.amp
	return clampf(s * 0.7, -1.0, 1.0)


func _bell_sample(base: float, age: float) -> float:
	if age < 0.0:
		return 0.0
	var s := 0.0
	for p in BELL_PARTIALS:
		s += p[1] * exp(-age / p[2]) * sin(TAU * base * p[0] * age)
	if age < 0.015:
		s += (randf() * 2.0 - 1.0) * (1.0 - age / 0.015) * 0.6
	return s * 0.5
