extends Control
class_name EvidenceBoard

## TABLERO DE PISTAS — "cork board" de detective noir.
## Overlay a pantalla completa que se monta SOLO por código leyendo el estado del
## juego (Global.met_chars + Global.clues + Story.CHARS). Muestra las fotos de los
## personajes conocidos y las notas de las pistas, clavadas con chinchetas y unidas
## por un hilo rojo de conspiración. Las pistas falsas van tachadas.
##
## Uso:  var board := EvidenceBoard.new(); add_child(board)
## Se cierra solo (queue_free) al pulsar el fondo o el botón "Cerrar".

# --- Paleta corcho / madera / papel ---
const COL_CORK := Color(0.22, 0.16, 0.11)
const COL_WOOD := Color(0.11, 0.08, 0.05)
const COL_PAPER := Color(0.86, 0.82, 0.70)
const COL_PAPER_OFF := Color(0.62, 0.60, 0.55)   # papel grisáceo (pistas descartadas)
const COL_INK := Color(0.14, 0.11, 0.08)
const COL_CREAM := Color(0.96, 0.90, 0.78)

# --- Geometría de los elementos (tamaños fijos -> rejilla determinista) ---
const CELL := Vector2(244, 252)
const PHOTO_ITEM := Vector2(174, 224)
const PHOTO_FRAME := Vector2(150, 175)
const NOTE_ITEM := Vector2(214, 202)
const PIN_R := 8.0

# --- Zoom manual (se aplica ENCIMA del auto-fit) ---
const ZOOM_MIN := 0.6
const ZOOM_MAX := 3.0
const ZOOM_STEP := 0.1

var _viewport: Control              # área clipada que muestra el contenido
var _content_host: Control          # lienzo donde se clavan fotos/notas
var _thread: Line2D                 # hilo rojo (detrás de todo)
var _pin_points: PackedVector2Array = PackedVector2Array()

# --- Estado de encaje (auto-fit) + zoom/arrastre manual ---
var _region: Vector2 = Vector2.ZERO     # tamaño visible del viewport
var _grid_size: Vector2 = Vector2.ZERO  # bounding box de la rejilla (sin escala)
var _zoom: float = 1.0
var _pan: Vector2 = Vector2.ZERO
var _dragging: bool = false
var _zoom_label: Label
var _touches: Dictionary = {}   # index -> pos (pinch de 2 dedos en Android)
var _pinch_base: float = 0.0
var _pinch_zoom0: float = 1.0


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE   # el fondo captura; el panel bloquea

	_build_backdrop()
	_build_board()

	# Fade-in del overlay completo.
	modulate.a = 0.0
	var tw := create_tween()
	tw.tween_property(self, "modulate:a", 1.0, 0.3)


# ---------------------------------------------------------------------------
#  FONDO OSCURO (cierra al pulsar)
# ---------------------------------------------------------------------------
func _build_backdrop() -> void:
	var backdrop := ColorRect.new()
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	backdrop.color = Color(0.0, 0.0, 0.0, 0.6)
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	backdrop.gui_input.connect(_on_backdrop_input)
	add_child(backdrop)


func _on_backdrop_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_close()
	elif event is InputEventScreenTouch and event.pressed:
		_close()


# ---------------------------------------------------------------------------
#  TABLERO (panel corcho con marco de madera)
# ---------------------------------------------------------------------------
func _build_board() -> void:
	var vp := get_viewport_rect().size
	if vp.x <= 0.0 or vp.y <= 0.0:
		vp = Vector2(1280, 720)
	var board_size := Vector2(minf(vp.x - 80.0, 1040.0), minf(vp.y - 80.0, 680.0))

	# CenterContainer a pantalla completa -> el tablero SIEMPRE queda centrado.
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(center)

	var board := Panel.new()
	board.mouse_filter = Control.MOUSE_FILTER_STOP   # los clics sobre el tablero NO cierran
	board.custom_minimum_size = board_size

	var sb := StyleBoxFlat.new()
	sb.bg_color = COL_CORK
	sb.set_border_width_all(16)          # marco de madera grueso
	sb.border_color = COL_WOOD
	sb.set_corner_radius_all(10)
	sb.shadow_color = Color(0, 0, 0, 0.75)
	sb.shadow_size = 34
	sb.shadow_offset = Vector2(0, 14)
	board.add_theme_stylebox_override("panel", sb)
	center.add_child(board)   # dentro del CenterContainer -> centrado V y H

	# --- Título ---
	var title := Label.new()
	title.text = Global.loc("TABLERO DE PISTAS")
	title.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_override("font", Global.font_title)
	title.add_theme_font_size_override("font_size", 30)
	title.add_theme_color_override("font_color", COL_CREAM)
	title.add_theme_color_override("font_outline_color", Color.BLACK)
	title.add_theme_constant_override("outline_size", 6)
	title.set_anchors_preset(Control.PRESET_TOP_WIDE)
	title.offset_top = 18
	title.offset_left = 40
	title.offset_right = -40
	board.add_child(title)

	# --- Botón cerrar (arriba a la derecha del tablero) ---
	var close := _make_close_button()
	board.add_child(close)

	# --- Zona de contenido: "viewport" clipado (sin scroll; auto-fit + zoom) ---
	_viewport = Control.new()
	_viewport.clip_contents = true
	_viewport.set_anchors_preset(Control.PRESET_FULL_RECT)
	_viewport.offset_left = 24
	_viewport.offset_right = -24
	_viewport.offset_top = 66
	_viewport.offset_bottom = -22
	_viewport.mouse_filter = Control.MOUSE_FILTER_STOP   # captura rueda/arrastre
	_viewport.gui_input.connect(_on_viewport_input)
	board.add_child(_viewport)

	_region = Vector2(board_size.x - 48.0, board_size.y - 66.0 - 22.0)

	# Lienzo dimensionado al bounding box de la rejilla; se centra y escala
	# (fit*zoom) dentro del viewport en _apply_transform().
	_content_host = Control.new()
	_content_host.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_viewport.add_child(_content_host)

	# Hilo rojo: primer hijo -> se dibuja DETRÁS de fotos y notas.
	_thread = Line2D.new()
	_thread.width = 3.0
	_thread.default_color = Color(Global.COL_ACCENT.r, Global.COL_ACCENT.g, Global.COL_ACCENT.b, 0.85)
	_thread.begin_cap_mode = Line2D.LINE_CAP_ROUND
	_thread.end_cap_mode = Line2D.LINE_CAP_ROUND
	_thread.joint_mode = Line2D.LINE_JOINT_ROUND
	_content_host.add_child(_thread)

	_populate(_region.x, _region.y)

	# --- Botones de zoom (+/−) grandes, abajo a la derecha del corcho ---
	_build_zoom_controls(board)


# ---------------------------------------------------------------------------
#  CONTENIDO DINÁMICO
# ---------------------------------------------------------------------------
func _populate(content_w: float, region_h: float) -> void:
	# Recopila los elementos a clavar: fotos de personajes conocidos + notas de pistas.
	var items: Array = []   # cada uno: {"kind","node","crossed"}
	for k in Global.met_chars:
		var key := String(k)
		if not Story.CHARS.has(key):
			continue
		items.append({"node": _make_photo(key), "crossed": false})
	for c in Global.clues:
		if typeof(c) != TYPE_DICTIONARY:
			continue
		var is_false: bool = bool(c.get("false", false))
		items.append({"node": _make_note(c, is_false), "crossed": is_false})

	# Nada clavado todavía. El lienzo cubre la región para centrar el mensaje.
	if items.is_empty():
		_grid_size = Vector2(content_w, region_h)
		_content_host.size = _grid_size
		_content_host.custom_minimum_size = _grid_size
		_content_host.pivot_offset = _grid_size * 0.5
		var empty := Label.new()
		empty.text = Global.loc("Aún no has clavado nada en el tablero. Sigue investigando.")
		empty.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
		empty.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		empty.add_theme_font_size_override("font_size", 20)
		empty.add_theme_color_override("font_color", COL_CREAM)
		empty.add_theme_color_override("font_outline_color", Color.BLACK)
		empty.add_theme_constant_override("outline_size", 5)
		empty.position = Vector2(content_w * 0.16, region_h * 0.5 - 40.0)
		empty.custom_minimum_size = Vector2(content_w * 0.68, 0)
		empty.size = Vector2(content_w * 0.68, 80)
		_content_host.add_child(empty)
		_apply_transform()
		return

	# Rejilla compacta y equilibrada (casi cuadrada): el auto-fit la encoge para
	# que SIEMPRE quepa entera, así que preferimos pocas filas/columnas anchas.
	var cols: int = maxi(1, int(ceil(sqrt(float(items.size())))))
	cols = mini(cols, items.size())
	var rows: int = int(ceil(float(items.size()) / float(cols)))
	var grid_w: float = float(cols) * CELL.x
	var grid_h: float = float(rows) * CELL.y

	_pin_points = PackedVector2Array()
	for i in items.size():
		var it: Dictionary = items[i]
		var node: Control = it["node"]
		var col: int = i % cols
		var row: int = i / cols
		var cell_origin := Vector2(float(col) * CELL.x, float(row) * CELL.y)
		var jitter := Vector2(randf_range(-8.0, 8.0), randf_range(-8.0, 8.0))
		node.position = cell_origin + (CELL - node.size) * 0.5 + jitter
		node.pivot_offset = node.size * 0.5
		node.rotation_degrees = randf_range(-3.0, 3.0)
		_content_host.add_child(node)

		# Punto de la chincheta (arriba-centro), ya rotado, para trazar el hilo.
		var center := node.position + node.size * 0.5
		var pin_off := Vector2(0.0, PIN_R + 4.0 - node.size.y * 0.5).rotated(node.rotation)
		if not bool(it["crossed"]):
			_pin_points.append(center + pin_off)

	# El lienzo mide EXACTAMENTE el bounding box de la rejilla; su centro es el pivote.
	_grid_size = Vector2(grid_w, grid_h)
	_content_host.size = _grid_size
	_content_host.custom_minimum_size = _grid_size
	_content_host.pivot_offset = _grid_size * 0.5

	# Hilo rojo por las chinchetas de los elementos NO tachados.
	if _pin_points.size() >= 2:
		_thread.points = _pin_points

	_apply_transform()


# ---------------------------------------------------------------------------
#  ENCAJE (auto-fit) + ZOOM/ARRASTRE
# ---------------------------------------------------------------------------
## Centra el lienzo en el viewport y le aplica escala = fit * zoom, donde
## fit = min(1, region.x/grid_w, region.y/grid_h). Con 0/pocas/muchas pistas
## el contenido queda SIEMPRE centrado y, sin zoom, cabe entero sin scroll.
func _apply_transform() -> void:
	if _content_host == null or _grid_size.x <= 0.0 or _grid_size.y <= 0.0:
		return
	var fit: float = 1.0
	fit = minf(fit, _region.x / _grid_size.x)
	fit = minf(fit, _region.y / _grid_size.y)
	var eff: float = maxf(0.01, fit * _zoom)
	_content_host.scale = Vector2(eff, eff)
	_clamp_pan(eff)
	# Pivote en el centro del lienzo => el centro visual = position + pivot_offset,
	# invariante a la escala. Lo situamos en el centro de la región + arrastre.
	_content_host.position = _region * 0.5 - _grid_size * 0.5 + _pan
	if _zoom_label:
		_zoom_label.text = "×%.1f" % _zoom


## Limita el arrastre al desbordamiento real del contenido escalado; si cabe
## entero (sin zoom) el pan se anula y todo permanece centrado.
func _clamp_pan(eff: float) -> void:
	var scaled: Vector2 = _grid_size * eff
	var mx: float = maxf(0.0, (scaled.x - _region.x) * 0.5)
	var my: float = maxf(0.0, (scaled.y - _region.y) * 0.5)
	_pan.x = clampf(_pan.x, -mx, mx)
	_pan.y = clampf(_pan.y, -my, my)


func _add_zoom(delta: float) -> void:
	var prev := _zoom
	_zoom = clampf(_zoom + delta, ZOOM_MIN, ZOOM_MAX)
	if not is_equal_approx(_zoom, prev):
		Global.play_sfx(Global.SFX_CLICK, -12.0)
	_apply_transform()


func _pinch_distance() -> float:
	var pts: Array = _touches.values()
	if pts.size() < 2:
		return 0.0
	return (pts[0] as Vector2).distance_to(pts[1] as Vector2)


func _on_viewport_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			_add_zoom(ZOOM_STEP)
			_viewport.accept_event()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			_add_zoom(-ZOOM_STEP)
			_viewport.accept_event()
		elif event.button_index == MOUSE_BUTTON_LEFT:
			_dragging = event.pressed
			_viewport.accept_event()
	elif event is InputEventMouseMotion and _dragging:
		_pan += event.relative
		_apply_transform()
	elif event is InputEventScreenTouch:
		if event.pressed:
			_touches[event.index] = event.position
		else:
			_touches.erase(event.index)
		if _touches.size() >= 2:
			_pinch_base = _pinch_distance()
			_pinch_zoom0 = _zoom
		_dragging = _touches.size() == 1
		_viewport.accept_event()
	elif event is InputEventScreenDrag:
		_touches[event.index] = event.position
		if _touches.size() >= 2:
			# Pinch: la separación de los dos dedos escala el zoom (paso continuo).
			var d := _pinch_distance()
			if _pinch_base > 1.0:
				_zoom = clampf(_pinch_zoom0 * (d / _pinch_base), ZOOM_MIN, ZOOM_MAX)
				_apply_transform()
		elif _dragging:
			_pan += event.relative
			_apply_transform()
		_viewport.accept_event()


# ---------------------------------------------------------------------------
#  CONTROLES DE ZOOM (+/−)
# ---------------------------------------------------------------------------
func _build_zoom_controls(board: Panel) -> void:
	var box := VBoxContainer.new()
	box.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	box.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	box.grow_vertical = Control.GROW_DIRECTION_BEGIN
	box.offset_left = -92
	box.offset_top = -206
	box.offset_right = -20
	box.offset_bottom = -20
	box.add_theme_constant_override("separation", 10)
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	board.add_child(box)

	var b_plus := _make_zoom_button("+")
	b_plus.pressed.connect(func() -> void: _add_zoom(ZOOM_STEP))
	box.add_child(b_plus)

	_zoom_label = Label.new()
	_zoom_label.custom_minimum_size = Vector2(64, 0)
	_zoom_label.text = "×1.0"
	_zoom_label.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
	_zoom_label.add_theme_font_size_override("font_size", 15)
	_zoom_label.add_theme_color_override("font_color", COL_CREAM)
	_zoom_label.add_theme_color_override("font_outline_color", Color.BLACK)
	_zoom_label.add_theme_constant_override("outline_size", 4)
	_zoom_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(_zoom_label)

	var b_minus := _make_zoom_button("−")
	b_minus.pressed.connect(func() -> void: _add_zoom(-ZOOM_STEP))
	box.add_child(b_minus)


func _make_zoom_button(txt: String) -> Button:
	var b := Button.new()
	b.text = txt
	b.custom_minimum_size = Vector2(64, 56)
	b.focus_mode = Control.FOCUS_NONE
	b.mouse_filter = Control.MOUSE_FILTER_STOP
	b.add_theme_font_size_override("font_size", 32)
	b.add_theme_color_override("font_color", COL_CREAM)
	b.add_theme_color_override("font_hover_color", Color(1, 1, 1))
	b.add_theme_color_override("font_outline_color", Color.BLACK)
	b.add_theme_constant_override("outline_size", 4)
	var mk := func(bg: Color) -> StyleBoxFlat:
		var sb := StyleBoxFlat.new()
		sb.bg_color = bg
		sb.set_corner_radius_all(8)
		sb.set_border_width_all(2)
		sb.border_color = Global.COL_ACCENT
		return sb
	b.add_theme_stylebox_override("normal", mk.call(Color(0.14, 0.10, 0.07, 0.96)))
	b.add_theme_stylebox_override("hover", mk.call(Color(0.22, 0.14, 0.09, 1.0)))
	b.add_theme_stylebox_override("pressed", mk.call(Color(0.28, 0.16, 0.10, 1.0)))
	return b


# ---------------------------------------------------------------------------
#  FOTO FIJADA (personaje conocido)
# ---------------------------------------------------------------------------
func _make_photo(key: String) -> Control:
	var info: Dictionary = Story.CHARS[key]
	var item := Control.new()
	item.custom_minimum_size = PHOTO_ITEM
	item.size = PHOTO_ITEM
	item.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# Marco tipo foto (borde claro) con el retrato recortado dentro.
	var frame := Panel.new()
	frame.clip_contents = true
	frame.size = PHOTO_FRAME
	frame.position = Vector2((PHOTO_ITEM.x - PHOTO_FRAME.x) * 0.5, 12.0)
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var fsb := StyleBoxFlat.new()
	fsb.bg_color = Color(0.08, 0.08, 0.09, 1.0)
	fsb.set_border_width_all(5)
	fsb.border_color = Color(0.93, 0.90, 0.84)     # borde de foto revelada
	fsb.set_corner_radius_all(2)
	fsb.shadow_color = Color(0, 0, 0, 0.55)
	fsb.shadow_size = 10
	fsb.shadow_offset = Vector2(3, 5)
	frame.add_theme_stylebox_override("panel", fsb)
	item.add_child(frame)

	var portrait := String(info.get("portrait", ""))
	if portrait != "" and ResourceLoader.exists(portrait):
		var tex := TextureRect.new()
		tex.set_anchors_preset(Control.PRESET_FULL_RECT)
		tex.offset_left = 5
		tex.offset_top = 5
		tex.offset_right = -5
		tex.offset_bottom = -5
		tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		tex.texture = load(portrait)
		tex.mouse_filter = Control.MOUSE_FILTER_IGNORE
		frame.add_child(tex)
	else:
		# Sin retrato: marcador con la inicial del nombre, no rompe.
		var ph := Label.new()
		ph.set_anchors_preset(Control.PRESET_FULL_RECT)
		ph.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
		ph.vertical_alignment = VerticalAlignment.VERTICAL_ALIGNMENT_CENTER
		var nm := String(info.get("name", "?"))
		ph.text = nm.substr(0, 1) if nm != "" else "?"
		ph.add_theme_font_size_override("font_size", 48)
		ph.add_theme_color_override("font_color", Color(info.get("color", COL_CREAM)))
		frame.add_child(ph)

	# Nombre debajo, en una tira de papel/etiqueta.
	var name_lbl := Label.new()
	name_lbl.text = String(info.get("name", "?"))
	name_lbl.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
	name_lbl.clip_text = true
	name_lbl.position = Vector2(0, 12.0 + PHOTO_FRAME.y + 6.0)
	name_lbl.size = Vector2(PHOTO_ITEM.x, 24)
	name_lbl.add_theme_font_size_override("font_size", 16)
	name_lbl.add_theme_color_override("font_color", COL_CREAM)
	name_lbl.add_theme_color_override("font_outline_color", Color.BLACK)
	name_lbl.add_theme_constant_override("outline_size", 5)
	name_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	item.add_child(name_lbl)

	item.add_child(_make_pin(PHOTO_ITEM.x * 0.5))
	return item


# ---------------------------------------------------------------------------
#  NOTA DE PAPEL (pista)
# ---------------------------------------------------------------------------
func _make_note(clue: Dictionary, is_false: bool) -> Control:
	var item := Control.new()
	item.custom_minimum_size = NOTE_ITEM
	item.size = NOTE_ITEM
	item.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var paper := Panel.new()
	paper.clip_contents = true
	paper.position = Vector2(0, 10.0)
	paper.size = Vector2(NOTE_ITEM.x, NOTE_ITEM.y - 10.0)
	paper.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var psb := StyleBoxFlat.new()
	psb.bg_color = COL_PAPER_OFF if is_false else COL_PAPER
	psb.set_corner_radius_all(3)
	psb.set_border_width_all(1)
	psb.border_color = Color(0.55, 0.50, 0.40)
	psb.shadow_color = Color(0, 0, 0, 0.5)
	psb.shadow_size = 9
	psb.shadow_offset = Vector2(3, 5)
	psb.content_margin_left = 12
	psb.content_margin_right = 12
	psb.content_margin_top = 12
	psb.content_margin_bottom = 10
	paper.add_theme_stylebox_override("panel", psb)
	item.add_child(paper)

	var vb := VBoxContainer.new()
	vb.set_anchors_preset(Control.PRESET_FULL_RECT)
	vb.offset_left = 12
	vb.offset_top = 12
	vb.offset_right = -12
	vb.offset_bottom = -10
	vb.add_theme_constant_override("separation", 6)
	vb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	paper.add_child(vb)

	var ink := Color(0.30, 0.30, 0.30) if is_false else COL_INK

	var title := Label.new()
	title.text = Global.loc(String(clue.get("title", "")))
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title.add_theme_font_size_override("font_size", 18)   # negrita "visual" por tamaño
	title.add_theme_color_override("font_color", ink)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_child(title)

	var body := Label.new()
	body.text = Global.loc(String(clue.get("text", "")))
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.clip_text = true
	body.add_theme_font_size_override("font_size", 12)
	body.add_theme_color_override("font_color", ink)
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_child(body)

	# Pista descartada: gran ✗ roja tachando la nota.
	if is_false:
		var cross := Label.new()
		cross.text = "✗"
		cross.set_anchors_preset(Control.PRESET_FULL_RECT)
		cross.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
		cross.vertical_alignment = VerticalAlignment.VERTICAL_ALIGNMENT_CENTER
		cross.add_theme_font_size_override("font_size", 120)
		cross.add_theme_color_override("font_color", Color(Global.COL_ACCENT.r, Global.COL_ACCENT.g, Global.COL_ACCENT.b, 0.8))
		cross.mouse_filter = Control.MOUSE_FILTER_IGNORE
		paper.add_child(cross)

	item.add_child(_make_pin(NOTE_ITEM.x * 0.5))
	return item


# ---------------------------------------------------------------------------
#  CHINCHETA ROJA
# ---------------------------------------------------------------------------
func _make_pin(cx: float) -> Control:
	var d := PIN_R * 2.0
	var pin := Panel.new()
	pin.size = Vector2(d, d)
	pin.position = Vector2(cx - PIN_R, -2.0)
	pin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sb := StyleBoxFlat.new()
	sb.bg_color = Global.COL_ACCENT
	sb.set_corner_radius_all(int(PIN_R))
	sb.set_border_width_all(2)
	sb.border_color = Color(0.35, 0.05, 0.05)
	sb.shadow_color = Color(0, 0, 0, 0.6)
	sb.shadow_size = 6
	sb.shadow_offset = Vector2(2, 3)
	pin.add_theme_stylebox_override("panel", sb)
	return pin


# ---------------------------------------------------------------------------
#  BOTÓN CERRAR
# ---------------------------------------------------------------------------
func _make_close_button() -> Button:
	var btn := Button.new()
	var icon := "res://assets/ui/ic_close.png"
	if ResourceLoader.exists(icon):
		btn.icon = load(icon)
		btn.expand_icon = true
		btn.custom_minimum_size = Vector2(40, 40)
	else:
		btn.text = Global.loc("Cerrar")
		btn.add_theme_font_size_override("font_size", 16)
		btn.custom_minimum_size = Vector2(0, 36)
	btn.add_theme_color_override("font_color", COL_CREAM)
	btn.add_theme_color_override("font_outline_color", Color.BLACK)
	btn.add_theme_constant_override("outline_size", 4)

	var normal := StyleBoxFlat.new()
	normal.bg_color = Color(0.14, 0.10, 0.07, 0.96)
	normal.set_corner_radius_all(6)
	normal.set_border_width_all(2)
	normal.border_color = Global.COL_ACCENT
	normal.content_margin_left = 12
	normal.content_margin_right = 12
	normal.content_margin_top = 6
	normal.content_margin_bottom = 6
	btn.add_theme_stylebox_override("normal", normal)
	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = Color(0.22, 0.14, 0.09, 1.0)
	btn.add_theme_stylebox_override("hover", hover)
	var pressed := normal.duplicate() as StyleBoxFlat
	pressed.bg_color = Color(0.28, 0.16, 0.10, 1.0)
	btn.add_theme_stylebox_override("pressed", pressed)

	btn.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	btn.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	btn.offset_top = 12
	btn.offset_right = -12
	btn.mouse_filter = Control.MOUSE_FILTER_STOP
	btn.pressed.connect(_close)
	return btn


# ---------------------------------------------------------------------------
#  CIERRE
# ---------------------------------------------------------------------------
func _close() -> void:
	if not is_inside_tree():
		return
	Global.play_sfx(Global.SFX_BACK, -6.0)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_process_input(false)
	var tw := create_tween()
	tw.tween_property(self, "modulate:a", 0.0, 0.2)
	tw.tween_callback(queue_free)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") or event.is_action_pressed("notebook"):
		accept_event()
		_close()
