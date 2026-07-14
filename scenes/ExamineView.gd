extends Control
class_name ExamineView
## Mecánica 5: EXAMINAR una prueba con lupa.
## Se muestra una "prueba" (la imagen de `data.bg`) que el jugador puede ampliar
## (botones +/− o rueda del ratón) y arrastrar. En una posición hay un DETALLE
## oculto: solo se hace visible/clicable cuando el zoom es suficiente (≥ 1.4).
## Al tocarlo, se descubre la pista, se cumple el contrato y la escena termina.
##
## Uso:
##   var ev := ExamineView.new()
##   add_child(ev)
##   ev.finished.connect(_on_finished)
##   ev.start({...})

signal finished(result: Dictionary)

const ZOOM_MIN := 1.0
const ZOOM_MAX := 3.0
const ZOOM_REVEAL := 1.4     # a partir de aquí el detalle se ve y se puede tocar
const ZOOM_STEP := 0.22

var _data: Dictionary = {}
var _done := false

# Estado de zoom / desplazamiento
var _zoom := 1.0
var _pan := Vector2.ZERO
var _dragging := false
var _base_size := Vector2(1000, 640)   # tamaño (sin zoom) de la imagen ya ajustada
var _img_native := Vector2(1280, 800)  # tamaño natural de la textura

# Nodos
var _stage: Control
var _img: TextureRect
var _detail: Button
var _detail_ring: Panel
var _hint: Label
var _zoom_label: Label
var _toast: Label


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP


func start(data: Dictionary) -> void:
	_data = data
	_build_ui()
	_load_evidence()
	_compute_fit()
	_apply_transform()
	_refresh_hint()
	# Aparición suave
	modulate.a = 0.0
	var t := create_tween()
	t.tween_property(self, "modulate:a", 1.0, 0.35)


# ---------------------------------------------------------------------------
#  CONSTRUCCIÓN DE LA UI
# ---------------------------------------------------------------------------
func _build_ui() -> void:
	# Fondo de respaldo (gradiente oscuro)
	var grad := ColorRect.new()
	grad.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	grad.color = Color(0.03, 0.035, 0.05, 1.0)
	grad.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sh := Shader.new()
	sh.code = """
shader_type canvas_item;
void fragment() {
	float vig = smoothstep(1.15, 0.30, length(UV - 0.5));
	vec3 c = mix(vec3(0.02,0.03,0.05), vec3(0.07,0.08,0.11), vig);
	COLOR = vec4(c, 1.0);
}
"""
	var mat := ShaderMaterial.new()
	mat.shader = sh
	grad.material = mat
	add_child(grad)

	# Escenario: recorta la imagen y captura zoom/arrastre.
	_stage = Control.new()
	_stage.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_stage.clip_contents = true
	_stage.mouse_filter = Control.MOUSE_FILTER_STOP
	_stage.gui_input.connect(_on_stage_input)
	add_child(_stage)

	# La imagen (prueba a examinar). El zoom cambia su scale; el arrastre su position.
	_img = TextureRect.new()
	_img.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_img.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_img.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	_img.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stage.add_child(_img)

	# Anillo del detalle: hijo de la imagen -> se mueve y escala con ella.
	# Solo se ve/clicka cuando el zoom es suficiente.
	_detail = Button.new()
	_detail.flat = true
	_detail.focus_mode = Control.FOCUS_NONE
	_detail.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_detail.modulate.a = 0.0
	_detail.pressed.connect(_on_detail_pressed)
	_img.add_child(_detail)

	_detail_ring = Panel.new()
	_detail_ring.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_detail_ring.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var rsb := StyleBoxFlat.new()
	rsb.bg_color = Color(0.95, 0.66, 0.38, 0.10)
	rsb.set_corner_radius_all(200)
	rsb.set_border_width_all(3)
	rsb.border_color = Global.COL_WARM
	_detail_ring.add_theme_stylebox_override("panel", rsb)
	_detail.add_child(_detail_ring)

	# Cartel de instrucción arriba.
	var bar := Panel.new()
	bar.set_anchors_preset(Control.PRESET_TOP_WIDE)
	bar.offset_left = 40
	bar.offset_right = -40
	bar.offset_top = 24
	bar.offset_bottom = 118
	bar.mouse_filter = Control.MOUSE_FILTER_STOP
	bar.add_theme_stylebox_override("panel", _panel_style())
	add_child(bar)

	var intro := Label.new()
	intro.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	intro.offset_left = 18
	intro.offset_right = -18
	intro.offset_top = 12
	intro.offset_bottom = -12
	intro.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	intro.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	intro.text = Global.loc(String(_data.get("intro", "Examina la prueba: acércate con +/− (o la rueda) y arrastra.")))
	_style_label(intro, 18, Global.COL_TEXT)
	bar.add_child(intro)

	# Pista de estado (abajo-izquierda).
	_hint = Label.new()
	_hint.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	_hint.grow_vertical = Control.GROW_DIRECTION_BEGIN
	_hint.offset_left = 40
	_hint.offset_top = -60
	_hint.offset_right = 720
	_hint.offset_bottom = -24
	_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_style_label(_hint, 16, Global.COL_WARM)
	add_child(_hint)

	# Botones de zoom (grandes, táctiles) abajo-derecha.
	var zoom_box := VBoxContainer.new()
	zoom_box.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	zoom_box.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	zoom_box.grow_vertical = Control.GROW_DIRECTION_BEGIN
	zoom_box.offset_left = -108
	zoom_box.offset_top = -196
	zoom_box.offset_right = -28
	zoom_box.offset_bottom = -28
	zoom_box.add_theme_constant_override("separation", 12)
	add_child(zoom_box)

	var b_plus := _make_zoom_button("+")
	b_plus.pressed.connect(func() -> void: _add_zoom(ZOOM_STEP))
	zoom_box.add_child(b_plus)

	_zoom_label = Label.new()
	_zoom_label.custom_minimum_size = Vector2(80, 0)
	_zoom_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_style_label(_zoom_label, 15, Global.COL_TEXT_MUTED)
	zoom_box.add_child(_zoom_label)

	var b_minus := _make_zoom_button("−")
	b_minus.pressed.connect(func() -> void: _add_zoom(-ZOOM_STEP))
	zoom_box.add_child(b_minus)

	# Toast de acierto (centro, oculto).
	_toast = Label.new()
	_toast.set_anchors_preset(Control.PRESET_CENTER)
	_toast.anchor_left = 0.5
	_toast.anchor_right = 0.5
	_toast.anchor_top = 0.5
	_toast.anchor_bottom = 0.5
	_toast.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_toast.grow_vertical = Control.GROW_DIRECTION_BOTH
	_toast.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_toast.custom_minimum_size = Vector2(680, 0)
	_toast.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_toast.pivot_offset = Vector2(340, 24)
	_toast.modulate.a = 0.0
	_style_label(_toast, 26, Global.COL_WARM)
	add_child(_toast)


func _panel_style() -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.10, 0.09, 0.12, 0.95)
	sb.set_corner_radius_all(8)
	sb.set_border_width_all(2)
	sb.border_color = Global.COL_WARM
	sb.set_content_margin_all(10)
	return sb


func _make_zoom_button(txt: String) -> Button:
	var b := Button.new()
	b.text = txt
	b.custom_minimum_size = Vector2(80, 64)
	b.focus_mode = Control.FOCUS_NONE
	b.add_theme_font_size_override("font_size", 34)
	b.add_theme_color_override("font_color", Global.COL_TEXT)
	b.add_theme_color_override("font_hover_color", Color(1, 1, 1))
	var mk := func(active: bool) -> StyleBoxFlat:
		var sb := StyleBoxFlat.new()
		sb.bg_color = Color(0.16, 0.13, 0.10, 0.96) if active else Color(0.10, 0.09, 0.12, 0.95)
		sb.set_corner_radius_all(10)
		sb.set_border_width_all(2)
		sb.border_color = Global.COL_WARM
		return sb
	b.add_theme_stylebox_override("normal", mk.call(false))
	b.add_theme_stylebox_override("hover", mk.call(true))
	b.add_theme_stylebox_override("pressed", mk.call(true))
	return b


func _style_label(l: Label, size: int, col: Color) -> void:
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", col)
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
	l.add_theme_constant_override("outline_size", 4)


# ---------------------------------------------------------------------------
#  CARGA DE LA PRUEBA
# ---------------------------------------------------------------------------
func _load_evidence() -> void:
	var path := "res://assets/backgrounds/%s.png" % String(_data.get("bg", "plaza"))
	if ResourceLoader.exists(path):
		var tex: Texture2D = load(path)
		_img.texture = tex
		_img_native = tex.get_size()
	else:
		var tex := _placeholder_texture()
		_img.texture = tex
		_img_native = tex.get_size()


## Si aún no existe el arte, genera una "prueba" de respaldo: un muro con una
## marca grabada tenue en `detail_pos`, para que la mecánica funcione igual.
func _placeholder_texture() -> Texture2D:
	var w := 1280
	var h := 800
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	for y in h:
		for x in w:
			var n := 0.5 + 0.5 * sin(x * 0.08) * sin(y * 0.11)
			var v := 0.20 + 0.10 * n - 0.06 * (float(y) / h)
			img.set_pixel(x, y, Color(v * 0.9, v * 0.85, v * 0.8, 1.0))
	# Marca grabada tenue (sello) en la posición del detalle.
	var dp: Vector2 = _data.get("detail_pos", Vector2(0.5, 0.5))
	var cx := int(dp.x * w)
	var cy := int(dp.y * h)
	for a in range(0, 360, 3):
		var rad := deg_to_rad(a)
		for rr in range(24, 34):
			var px := cx + int(cos(rad) * rr)
			var py := cy + int(sin(rad) * rr)
			if px >= 0 and px < w and py >= 0 and py < h:
				img.set_pixel(px, py, Color(0.12, 0.10, 0.09, 1.0))
	return ImageTexture.create_from_image(img)


# ---------------------------------------------------------------------------
#  ZOOM Y DESPLAZAMIENTO
# ---------------------------------------------------------------------------
func _compute_fit() -> void:
	var vp := get_viewport_rect().size
	var avail := vp * 0.86
	var s: float = min(avail.x / _img_native.x, avail.y / _img_native.y)
	_base_size = _img_native * s
	_img.size = _base_size
	_img.pivot_offset = _base_size * 0.5

	# Detalle: posición local (px de la imagen ajustada) y radio proporcional.
	var dp: Vector2 = _data.get("detail_pos", Vector2(0.5, 0.5))
	var local_r: float = float(_data.get("detail_r", 70)) * (_base_size.x / _img_native.x)
	local_r = max(local_r, 34.0)
	var center := Vector2(dp.x * _base_size.x, dp.y * _base_size.y)
	_detail.size = Vector2(local_r * 2.0, local_r * 2.0)
	_detail.position = center - Vector2(local_r, local_r)
	var rsb := _detail_ring.get_theme_stylebox("panel") as StyleBoxFlat
	if rsb:
		rsb.set_corner_radius_all(int(local_r))


func _apply_transform() -> void:
	var vp := get_viewport_rect().size
	_clamp_pan()
	_img.scale = Vector2(_zoom, _zoom)
	# El pivote (centro) queda fijo bajo el escalado: lo situamos en el centro + pan.
	_img.position = vp * 0.5 + _pan - _base_size * 0.5
	_update_detail_visibility()
	if _zoom_label:
		_zoom_label.text = "×%.1f" % _zoom


func _clamp_pan() -> void:
	# Permite mover hasta que el borde de la imagen ampliada llegue al centro.
	var half := _base_size * _zoom * 0.5
	_pan.x = clampf(_pan.x, -half.x, half.x)
	_pan.y = clampf(_pan.y, -half.y, half.y)


func _add_zoom(delta: float) -> void:
	var prev := _zoom
	_zoom = clampf(_zoom + delta, ZOOM_MIN, ZOOM_MAX)
	if not is_equal_approx(_zoom, prev):
		Global.play_sfx(Global.SFX_CLICK, -12.0)
	_apply_transform()
	_refresh_hint()


func _update_detail_visibility() -> void:
	var reveal := _zoom >= ZOOM_REVEAL and not _done
	_detail.mouse_filter = Control.MOUSE_FILTER_STOP if reveal else Control.MOUSE_FILTER_IGNORE
	var target := 1.0 if reveal else 0.0
	if not is_equal_approx(_detail.modulate.a, target):
		var t := create_tween()
		t.tween_property(_detail, "modulate:a", target, 0.25)
	if reveal:
		# Pulso sutil del anillo para llamar la atención.
		var pulse: float = 0.35 + 0.35 * (0.5 + 0.5 * sin(Time.get_ticks_msec() * 0.004))
		var rsb := _detail_ring.get_theme_stylebox("panel") as StyleBoxFlat
		if rsb:
			rsb.bg_color = Color(0.95, 0.66, 0.38, pulse * 0.4)


func _process(_delta: float) -> void:
	if not _done and _zoom >= ZOOM_REVEAL:
		_update_detail_visibility()


# ---------------------------------------------------------------------------
#  ENTRADA (rueda + arrastre / táctil)
# ---------------------------------------------------------------------------
func _on_stage_input(event: InputEvent) -> void:
	if _done:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			_add_zoom(ZOOM_STEP)
			_stage.accept_event()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			_add_zoom(-ZOOM_STEP)
			_stage.accept_event()
		elif event.button_index == MOUSE_BUTTON_LEFT:
			_dragging = event.pressed
			_stage.accept_event()
	elif event is InputEventMouseMotion and _dragging:
		_pan += event.relative
		_apply_transform()
	elif event is InputEventScreenTouch:
		_dragging = event.pressed
	elif event is InputEventScreenDrag:
		_pan += event.relative
		_apply_transform()


func _refresh_hint() -> void:
	if _done:
		return
	if _zoom >= ZOOM_REVEAL:
		_hint.text = Global.loc("Ahí está: toca el detalle marcado.")
	else:
		_hint.text = Global.loc(String(_data.get("hint", "Acércate más para distinguir el detalle.")))


# ---------------------------------------------------------------------------
#  DESCUBRIMIENTO / FIN (contrato)
# ---------------------------------------------------------------------------
func _on_detail_pressed() -> void:
	if _done or _zoom < ZOOM_REVEAL:
		return
	_done = true
	_dragging = false
	Global.play_sfx(Global.SFX_CONFIRM, -4.0)

	# Pulso de acierto sobre el detalle.
	var tp := create_tween()
	tp.tween_property(_detail, "scale", Vector2(1.25, 1.25), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tp.tween_property(_detail, "scale", Vector2(1.0, 1.0), 0.15)

	# Toast con el texto de hallazgo.
	_hint.text = ""
	_toast.text = Global.loc(String(_data.get("found", "Ahí: un detalle que a simple vista no se veía.")))
	_toast.scale = Vector2(0.9, 0.9)
	var tt := create_tween().set_parallel(true)
	tt.tween_property(_toast, "modulate:a", 1.0, 0.3)
	tt.tween_property(_toast, "scale", Vector2(1.0, 1.0), 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	await get_tree().create_timer(1.4).timeout
	_finish()


func _finish() -> void:
	var result := {"clue": null, "flag": "", "false_count": 0}
	if _data.has("clue"):
		var cl: Dictionary = _data.clue
		Global.add_clue(cl.title, cl.text, cl.get("false", false))
		result.clue = cl
		if cl.get("false", false):
			result.false_count = 1
	if _data.has("flag"):
		Global.set_flag(String(_data.flag), true)
		result.flag = _data.flag

	var t := create_tween()
	t.tween_property(self, "modulate:a", 0.0, 0.3)
	await t.finished
	finished.emit(result)
	queue_free()
