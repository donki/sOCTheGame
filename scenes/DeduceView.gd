extends Control
class_name DeduceView

## Mecánica 3 — Tablero de deducción.
## Se muestran las pistas del caso como tarjetas ámbar y varias conclusiones
## posibles como botones grandes. El jugador elige la conclusión que se deduce
## de las pistas. Acierto -> SFX_CONFIRM, cartel de éxito, aplica flag y termina.
## Fallo -> SFX_BACK + aviso, sin bloquear (intentos infinitos).

signal finished(result: Dictionary)

var _data: Dictionary = {}
var _solution: int = 0
var _finished: bool = false

var _conclusion_buttons: Array[Button] = []
var _clue_cards: Array[Control] = []
var _lines_layer: Control
var _toast: Label
var _board_root: Control


func start(data: Dictionary) -> void:
	_data = data
	_solution = int(data.get("solution", 0))
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP

	_build_background()
	_build_ui()

	# Fade in.
	modulate.a = 0.0
	var tw := create_tween()
	tw.tween_property(self, "modulate:a", 1.0, 0.35)


# ---------------------------------------------------------------------------
# Construcción de UI
# ---------------------------------------------------------------------------

func _build_background() -> void:
	var base := ColorRect.new()
	base.set_anchors_preset(Control.PRESET_FULL_RECT)
	base.color = Color(Global.COL_BG_BOTTOM.r, Global.COL_BG_BOTTOM.g, Global.COL_BG_BOTTOM.b, 1.0)
	base.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(base)
	var tex := TextureRect.new()
	tex.set_anchors_preset(Control.PRESET_FULL_RECT)
	tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	var path := "res://assets/backgrounds/%s.png" % String(_data.get("bg", "archivo"))
	if ResourceLoader.exists(path):
		tex.texture = load(path)
	add_child(tex)

	var veil := ColorRect.new()
	veil.set_anchors_preset(Control.PRESET_FULL_RECT)
	veil.color = Color(0.0, 0.0, 0.0, 0.45)
	add_child(veil)
	# --- Marco cinematografico: vineta negra que se funde a la imagen (textura, fiable) ---
	var _mfrm := TextureRect.new()
	_mfrm.set_anchors_preset(Control.PRESET_FULL_RECT)
	_mfrm.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_mfrm.stretch_mode = TextureRect.STRETCH_SCALE
	if ResourceLoader.exists("res://assets/ui/frame_vignette.png"):
		_mfrm.texture = load("res://assets/ui/frame_vignette.png")
	add_child(_mfrm)


func _build_ui() -> void:
	# Capa de hilos (detrás de las tarjetas y botones).
	_lines_layer = Control.new()
	_lines_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	_lines_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_lines_layer)

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 28)
	margin.add_theme_constant_override("margin_right", 28)
	margin.add_theme_constant_override("margin_top", 18)
	margin.add_theme_constant_override("margin_bottom", 18)
	add_child(margin)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 10)
	col.alignment = BoxContainer.ALIGNMENT_CENTER
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	margin.add_child(col)

	# --- Cartel de instrucción (intro) ---
	col.add_child(_make_intro_bar(String(_data.get("intro", "Une las pistas."))))

	# --- Zona central: tarjetas de pistas ---
	_board_root = _make_panel()
	_board_root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var board_vbox := VBoxContainer.new()
	board_vbox.add_theme_constant_override("separation", 8)
	board_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_board_root.add_child(board_vbox)

	var clues_title := _make_label(Global.loc("Pistas reunidas"), 20, Global.COL_WARM)
	clues_title.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
	board_vbox.add_child(clues_title)

	var clues_flow := HFlowContainer.new()
	clues_flow.alignment = FlowContainer.ALIGNMENT_CENTER
	clues_flow.add_theme_constant_override("h_separation", 16)
	clues_flow.add_theme_constant_override("v_separation", 14)
	clues_flow.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	board_vbox.add_child(clues_flow)

	var clues_shown: Array = _data.get("clues_shown", [])
	for c in clues_shown:
		var card := _make_clue_card(String(c))
		clues_flow.add_child(card)
		_clue_cards.append(card)

	col.add_child(_board_root)

	# --- Conclusiones (botones grandes) ---
	var concl_label := _make_label(Global.loc("¿Qué se deduce?"), 20, Global.COL_TEXT)
	concl_label.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
	col.add_child(concl_label)

	var concl_box := VBoxContainer.new()
	concl_box.add_theme_constant_override("separation", 12)
	concl_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(concl_box)

	var conclusions: Array = _data.get("conclusions", [])
	for i in conclusions.size():
		var btn := _make_conclusion_button(String(conclusions[i]), i)
		concl_box.add_child(btn)
		_conclusion_buttons.append(btn)

	# --- Toast de feedback ---
	_toast = _make_label("", 22, Global.COL_WARM)
	_toast.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
	_toast.modulate.a = 0.0
	col.add_child(_toast)

	# Dibuja hilos cuando ya hay layout.
	call_deferred("_redraw_threads")


func _make_intro_bar(text: String) -> Control:
	var panel := _make_panel()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var lbl := _make_label(text, 15, Global.COL_TEXT)
	lbl.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
	lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_child(lbl)
	return panel


func _make_clue_card(title: String) -> Control:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(460, 0)
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.16, 0.12, 0.08, 0.96)
	sb.set_corner_radius_all(8)
	sb.set_border_width_all(2)
	sb.border_color = Global.COL_WARM
	sb.content_margin_left = 14
	sb.content_margin_right = 14
	sb.content_margin_top = 12
	sb.content_margin_bottom = 12
	panel.add_theme_stylebox_override("panel", sb)

	var vb := VBoxContainer.new()
	vb.add_theme_constant_override("separation", 6)
	panel.add_child(vb)

	var t := _make_label(title, 18, Global.COL_WARM)
	t.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vb.add_child(t)

	# Texto pequeño de la pista si la conocemos por título.
	var detail := _find_clue_text(title)
	if detail != "":
		var d := _make_label(detail, 13, Global.COL_TEXT)
		d.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		d.custom_minimum_size = Vector2(420, 0)
		vb.add_child(d)

	return panel


func _make_conclusion_button(text: String, index: int) -> Button:
	var btn := Button.new()
	btn.text = text
	btn.custom_minimum_size = Vector2(0, 56)
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn.add_theme_font_size_override("font_size", 19)
	btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	btn.add_theme_color_override("font_color", Global.COL_TEXT)
	btn.add_theme_color_override("font_outline_color", Color.BLACK)
	btn.add_theme_constant_override("outline_size", 4)

	var normal := StyleBoxFlat.new()
	normal.bg_color = Color(0.10, 0.09, 0.12, 0.95)
	normal.set_corner_radius_all(8)
	normal.set_border_width_all(2)
	normal.border_color = Global.COL_WARM
	normal.content_margin_left = 18
	normal.content_margin_right = 18
	normal.content_margin_top = 10
	normal.content_margin_bottom = 10
	btn.add_theme_stylebox_override("normal", normal)

	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = Color(0.18, 0.15, 0.10, 0.98)
	btn.add_theme_stylebox_override("hover", hover)

	var pressed := normal.duplicate() as StyleBoxFlat
	pressed.bg_color = Color(0.22, 0.18, 0.12, 1.0)
	btn.add_theme_stylebox_override("pressed", pressed)

	btn.pressed.connect(_on_conclusion_pressed.bind(index, btn))
	return btn


func _make_panel() -> PanelContainer:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.10, 0.09, 0.12, 0.95)
	sb.set_corner_radius_all(8)
	sb.set_border_width_all(2)
	sb.border_color = Global.COL_WARM
	sb.content_margin_left = 20
	sb.content_margin_right = 20
	sb.content_margin_top = 16
	sb.content_margin_bottom = 16
	panel.add_theme_stylebox_override("panel", sb)
	return panel


func _make_label(text: String, size: int, color: Color) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	l.add_theme_color_override("font_outline_color", Color.BLACK)
	l.add_theme_constant_override("outline_size", 4)
	return l


func _find_clue_text(title: String) -> String:
	for c in Global.clues:
		if typeof(c) == TYPE_DICTIONARY and String(c.get("title", "")) == title:
			return String(c.get("text", ""))
	return ""


# ---------------------------------------------------------------------------
# Hilos del tablero (plus visual)
# ---------------------------------------------------------------------------

func _redraw_threads() -> void:
	if not is_instance_valid(_lines_layer) or not is_instance_valid(_board_root):
		return
	for child in _lines_layer.get_children():
		child.queue_free()
	if _clue_cards.is_empty():
		return
	# Punto de convergencia: centro inferior del panel de tablero.
	var focus := _board_root.get_global_rect().get_center()
	focus.y = _board_root.get_global_rect().end.y
	for card in _clue_cards:
		if not is_instance_valid(card):
			continue
		var line := Line2D.new()
		line.width = 2.0
		line.default_color = Color(Global.COL_WARM.r, Global.COL_WARM.g, Global.COL_WARM.b, 0.35)
		var from := card.get_global_rect().get_center()
		line.add_point(from - _lines_layer.global_position)
		line.add_point(focus - _lines_layer.global_position)
		_lines_layer.add_child(line)


# ---------------------------------------------------------------------------
# Interacción
# ---------------------------------------------------------------------------

func _on_conclusion_pressed(index: int, btn: Button) -> void:
	if _finished:
		return
	if index == _solution:
		_on_correct(btn)
	else:
		_on_wrong(btn)


func _on_correct(btn: Button) -> void:
	_finished = true
	Global.play_sfx(Global.SFX_CONFIRM, -4.0)
	# Desactiva los botones para evitar dobles toques.
	for b in _conclusion_buttons:
		b.disabled = true
	# Resalta el botón acertado en ámbar.
	var win := StyleBoxFlat.new()
	win.bg_color = Color(0.20, 0.16, 0.09, 1.0)
	win.set_corner_radius_all(8)
	win.set_border_width_all(3)
	win.border_color = Global.COL_WARM
	win.content_margin_left = 18
	win.content_margin_right = 18
	win.content_margin_top = 10
	win.content_margin_bottom = 10
	btn.add_theme_stylebox_override("disabled", win)

	_show_toast(String(_data.get("solved", "¡Deducción correcta!")), Global.COL_WARM)
	_pulse(btn)

	# Pequeña pausa para leer el éxito, luego fade out + contrato.
	var t := create_tween()
	t.tween_interval(0.9)
	t.tween_callback(_complete)


func _on_wrong(btn: Button) -> void:
	Global.play_sfx(Global.SFX_BACK, -4.0)
	_show_toast(String(_data.get("wrong", "No cuadra con las pistas.")), Global.COL_ACCENT)
	# Sacudida sutil del botón fallido.
	var base := btn.position
	var t := create_tween()
	t.tween_property(btn, "position:x", base.x - 8.0, 0.05)
	t.tween_property(btn, "position:x", base.x + 8.0, 0.05)
	t.tween_property(btn, "position:x", base.x, 0.05)


func _pulse(node: Control) -> void:
	node.pivot_offset = node.size * 0.5
	var t := create_tween()
	t.tween_property(node, "scale", Vector2(1.06, 1.06), 0.12)
	t.tween_property(node, "scale", Vector2.ONE, 0.12)


func _show_toast(text: String, color: Color) -> void:
	if not is_instance_valid(_toast):
		return
	_toast.text = text
	_toast.add_theme_color_override("font_color", color)
	_toast.modulate.a = 0.0
	var t := create_tween()
	t.tween_property(_toast, "modulate:a", 1.0, 0.2)


# ---------------------------------------------------------------------------
# Contrato de finalización
# ---------------------------------------------------------------------------

func _complete() -> void:
	var result := {"clue": null, "flag": "", "false_count": 0}
	if _data.has("clue"):
		var clue: Dictionary = _data.clue
		Global.add_clue(clue.title, clue.text, clue.get("false", false))
		result.clue = clue
		if clue.get("false", false):
			result.false_count = 1
	if _data.has("flag"):
		Global.set_flag(String(_data.flag), true)
		result.flag = _data.flag

	var tw := create_tween()
	tw.tween_property(self, "modulate:a", 0.0, 0.3)
	tw.tween_callback(func() -> void:
		finished.emit(result)
		queue_free())
