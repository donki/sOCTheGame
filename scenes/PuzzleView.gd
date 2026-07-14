extends Control
class_name PuzzleView
## Mecanica 4: mini-puzzle diegetico (teclado numerico / caja fuerte).
## Un cajon/caja cerrado con teclado numerico. El jugador marca el codigo que
## revela una pista/recibo. Codigo correcto -> se abre -> pista + flag y termina.
##
## Uso:
##   var pv := PuzzleView.new()
##   add_child(pv)
##   pv.finished.connect(_on_puzzle_finished)
##   pv.start({... ver formato abajo ...})
##
## Forma de `data`:
##   {"type":"puzzle", "bg":"tienda", "flag":"done_l0b",
##    "clue":{"title":"...","text":"..."},
##    "intro":"El cajon del mostrador esta cerrado. Marca el codigo del recibo.",
##    "kind":"keypad", "code":"427",
##    "hint":"En el recibo pegado al mostrador: 4 · 2 · 7.",
##    "solved":"Cajon abierto! Dentro, la pista que buscabas."}

signal finished(result: Dictionary)

var _data: Dictionary = {}
var _code := ""            # codigo correcto
var _entered := ""         # lo tecleado hasta ahora
var _false_count := 0
var _done := false

# Nodos
var _bg: TextureRect
var _display: Label
var _display_panel: Panel
var _toast: Label


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP


func start(data: Dictionary) -> void:
	_data = data
	_code = String(data.get("code", ""))
	_build_ui()
	# Aparicion suave
	modulate.a = 0.0
	var t := create_tween()
	t.tween_property(self, "modulate:a", 1.0, 0.35)


# ---------------------------------------------------------------------------
#  CONSTRUCCION DE LA UI
# ---------------------------------------------------------------------------
func _build_ui() -> void:
	# Fondo (base opaca + imagen + velo oscuro)
	var base := ColorRect.new()
	base.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	base.color = Color(Global.COL_BG_BOTTOM.r, Global.COL_BG_BOTTOM.g, Global.COL_BG_BOTTOM.b, 1.0)
	base.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(base)
	_bg = TextureRect.new()
	_bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var bg_path := "res://assets/backgrounds/%s.png" % _data.get("bg", "plaza")
	if ResourceLoader.exists(bg_path):
		_bg.texture = load(bg_path)
	add_child(_bg)

	var veil := ColorRect.new()
	veil.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	veil.color = Color(0, 0, 0, 0.45)
	veil.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(veil)
	# --- Marco cinematografico: vineta negra que se funde a la imagen (textura, fiable) ---
	var _mfrm := TextureRect.new()
	_mfrm.set_anchors_preset(Control.PRESET_FULL_RECT)
	_mfrm.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_mfrm.stretch_mode = TextureRect.STRETCH_SCALE
	if ResourceLoader.exists("res://assets/ui/frame_vignette.png"):
		_mfrm.texture = load("res://assets/ui/frame_vignette.png")
	add_child(_mfrm)

	# Cartel de instruccion arriba (data.intro)
	var intro_panel := Panel.new()
	intro_panel.set_anchors_preset(Control.PRESET_TOP_WIDE)
	intro_panel.offset_left = 40
	intro_panel.offset_right = -40
	intro_panel.offset_top = 28
	intro_panel.offset_bottom = 92
	intro_panel.add_theme_stylebox_override("panel", _make_panel_style())
	intro_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(intro_panel)

	var intro := Label.new()
	intro.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	intro.offset_left = 20
	intro.offset_right = -20
	intro.text = Global.loc(String(_data.get("intro", "Marca el codigo.")))
	intro.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	intro.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	intro.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_style_text(intro, 20, Global.COL_TEXT)
	intro_panel.add_child(intro)

	# Cuerpo central: caja fuerte con display + teclado
	var box := Panel.new()
	box.set_anchors_preset(Control.PRESET_CENTER)
	box.anchor_left = 0.5
	box.anchor_right = 0.5
	box.anchor_top = 0.5
	box.anchor_bottom = 0.5
	box.grow_horizontal = Control.GROW_DIRECTION_BOTH
	box.grow_vertical = Control.GROW_DIRECTION_BOTH
	box.custom_minimum_size = Vector2(360, 560)
	box.offset_left = -180
	box.offset_right = 180
	box.offset_top = -260
	box.offset_bottom = 300
	box.add_theme_stylebox_override("panel", _make_panel_style())
	add_child(box)

	var col := VBoxContainer.new()
	col.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	col.offset_left = 24
	col.offset_right = -24
	col.offset_top = 22
	col.offset_bottom = -22
	col.add_theme_constant_override("separation", 16)
	box.add_child(col)

	# Display de lo tecleado
	_display_panel = Panel.new()
	_display_panel.custom_minimum_size = Vector2(0, 70)
	_display_panel.pivot_offset = Vector2(156, 35)
	var dsb := StyleBoxFlat.new()
	dsb.bg_color = Color(0.03, 0.05, 0.04, 1.0)
	dsb.set_corner_radius_all(6)
	dsb.set_border_width_all(2)
	dsb.border_color = Global.COL_WARM
	_display_panel.add_theme_stylebox_override("panel", dsb)
	col.add_child(_display_panel)

	_display = Label.new()
	_display.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_display.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_display.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_style_text(_display, 40, Global.COL_WARM)
	_display_panel.add_child(_display)

	# Teclado 3x4: 1..9, luego C 0 OK
	var grid := GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 12)
	grid.add_theme_constant_override("v_separation", 12)
	grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	col.add_child(grid)

	for n in range(1, 10):
		grid.add_child(_make_key(str(n), Global.COL_WARM))
	grid.add_child(_make_key("C", Global.COL_ACCENT))
	grid.add_child(_make_key("0", Global.COL_WARM))
	grid.add_child(_make_key("OK", Color(0.40, 0.85, 0.50), true))   # OK con borde verde

	# Pista visible (tutorial: no hay que adivinar a ciegas)
	if _data.has("hint"):
		var hint := Label.new()
		hint.text = Global.loc(String(_data.hint))
		hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_style_text(hint, 16, Global.COL_TEXT)
		col.add_child(hint)

	# Toast de feedback (acierto/fallo)
	_toast = Label.new()
	_toast.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	_toast.anchor_left = 0.5
	_toast.anchor_right = 0.5
	_toast.offset_top = -80
	_toast.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_toast.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_toast.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_toast.modulate.a = 0.0
	_style_text(_toast, 22, Global.COL_WARM)
	add_child(_toast)

	_refresh_display()


func _style_text(l: Label, size: int, color: Color) -> void:
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
	l.add_theme_constant_override("outline_size", 4)


func _make_panel_style() -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.10, 0.09, 0.12, 0.95)
	sb.set_corner_radius_all(8)
	sb.set_border_width_all(2)
	sb.border_color = Global.COL_WARM
	sb.set_content_margin_all(8)
	return sb


func _make_key(label: String, color: Color, wide := false) -> Button:
	var b := Button.new()
	b.text = label
	b.custom_minimum_size = Vector2(92, 78)
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.size_flags_vertical = Control.SIZE_EXPAND_FILL
	b.add_theme_font_size_override("font_size", 26)
	b.add_theme_color_override("font_color", Global.COL_TEXT)
	b.add_theme_color_override("font_hover_color", Color(1, 1, 1))
	b.add_theme_color_override("font_pressed_color", Color(1, 1, 1))
	b.add_theme_color_override("font_focus_color", Color(1, 1, 1))
	var mk := func(active: bool) -> StyleBoxFlat:
		var sb := StyleBoxFlat.new()
		sb.bg_color = Color(0.16, 0.14, 0.18, 0.98) if active else Color(0.07, 0.07, 0.10, 0.96)
		sb.set_corner_radius_all(8)
		sb.set_border_width_all(2)
		sb.border_color = color if active else Color(color.r, color.g, color.b, 0.55)
		return sb
	b.add_theme_stylebox_override("normal", mk.call(false))
	b.add_theme_stylebox_override("hover", mk.call(true))
	b.add_theme_stylebox_override("pressed", mk.call(true))
	b.add_theme_stylebox_override("focus", mk.call(false))
	b.pressed.connect(func() -> void: _on_key(label))
	return b


# ---------------------------------------------------------------------------
#  LOGICA
# ---------------------------------------------------------------------------
func _on_key(label: String) -> void:
	if _done:
		return
	match label:
		"C":
			Global.play_sfx(Global.SFX_BACK, -8.0)
			_entered = _entered.substr(0, maxi(0, _entered.length() - 1))
			_refresh_display()
		"OK":
			_submit()
		_:
			# Digito. Limitamos a la longitud del codigo para que sea comodo.
			if _entered.length() < maxi(_code.length(), 8):
				Global.play_sfx(Global.SFX_NOTE, -10.0)
				_entered += label
				_refresh_display()
				_pulse(_display_panel)


func _submit() -> void:
	if _entered == _code and not _code.is_empty():
		_success()
	else:
		# Fallo NO bloqueante: sonido, shake y borrar.
		Global.play_sfx(Global.SFX_BACK, -4.0)
		_false_count += 1
		_show_toast(Global.loc("Codigo incorrecto."), Global.COL_ACCENT)
		_shake(_display_panel)
		_entered = ""
		_refresh_display()


func _success() -> void:
	_done = true
	Global.play_sfx(Global.SFX_CONFIRM, -4.0)
	_show_toast(Global.loc(String(_data.get("solved", "Abierto!"))), Global.COL_WARM)
	_pulse(_display_panel)
	# Deja leer el toast un momento antes de cerrar.
	await get_tree().create_timer(1.4).timeout
	_finish()


func _refresh_display() -> void:
	if _entered.is_empty():
		_display.text = "_ _ _"
	else:
		var parts: Array = []
		for c in _entered:
			parts.append(c)
		_display.text = " ".join(parts)


func _show_toast(text: String, color: Color) -> void:
	_toast.text = text
	_toast.add_theme_color_override("font_color", color)
	var t := create_tween()
	t.tween_property(_toast, "modulate:a", 1.0, 0.15)
	t.tween_interval(1.0)
	t.tween_property(_toast, "modulate:a", 0.0, 0.4)


func _pulse(node: Control) -> void:
	node.scale = Vector2(1.04, 1.04)
	var t := create_tween()
	t.tween_property(node, "scale", Vector2(1, 1), 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func _shake(node: Control) -> void:
	var base := node.position
	var t := create_tween()
	for i in range(6):
		var dx := 10.0 if i % 2 == 0 else -10.0
		t.tween_property(node, "position:x", base.x + dx, 0.04)
	t.tween_property(node, "position:x", base.x, 0.04)


# ---------------------------------------------------------------------------
#  FIN (contrato)
# ---------------------------------------------------------------------------
func _finish() -> void:
	var result := {"clue": null, "flag": "", "false_count": _false_count}
	if _data.has("clue"):
		Global.add_clue(_data.clue.title, _data.clue.text, _data.clue.get("false", false))
		result.clue = _data.clue
		if _data.clue.get("false", false):
			result.false_count += 1
	if _data.has("flag"):
		Global.set_flag(String(_data.flag), true)
		result.flag = _data.flag
	var t := create_tween()
	t.tween_property(self, "modulate:a", 0.0, 0.3)
	await t.finished
	finished.emit(result)
	queue_free()
