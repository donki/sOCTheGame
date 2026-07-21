extends Control
class_name EvidenceBoard

## TABLERO DE PISTAS — "cork board" de detective noir.
## Overlay a pantalla completa que se monta SOLO por código leyendo el estado del
## juego (Global.met_chars + Global.clues + Story.CHARS). Muestra las fotos de los
## personajes conocidos y las notas de las pistas, clavadas con chinchetas y unidas
## por un hilo rojo de conspiración. Las pistas falsas van tachadas.
##
## Tiene DOS modos:
##  - Escaparate (por defecto): el hilo lo teje el propio tablero y no se juega.
##    Es lo que ven los capítulos sin parejas definidas.
##  - JUGABLE: si el capítulo define parejas (Story.links()) y ya están TODAS sus
##    pistas descubiertas, el hilo lo tiende el jugador arrastrando de una pista a
##    otra. Unir las parejas correctas CIERRA EL CASO: se emite `case_closed` y
##    CityMap encadena el epílogo, que es quien avanza de capítulo.
##
## Uso:  var board := EvidenceBoard.new(); add_child(board)
## Se cierra solo (queue_free) al pulsar el fondo o el botón "Cerrar".

## El jugador ha unido todas las parejas del capítulo: el caso queda cerrado.
signal case_closed

# --- Paleta corcho / madera / papel ---
const COL_CORK := Color(0.22, 0.16, 0.11)
const COL_WOOD := Color(0.11, 0.08, 0.05)
const COL_PAPER := Color(0.86, 0.82, 0.70)
const COL_PAPER_OFF := Color(0.62, 0.60, 0.55)   # papel grisáceo (pistas descartadas)
const COL_INK := Color(0.14, 0.11, 0.08)
const COL_CREAM := Color(0.96, 0.90, 0.78)

# --- Geometría de los elementos (tamaños fijos -> celdas; colocación orgánica) ---
const CELL := Vector2(250, 262)
const PHOTO_ITEM := Vector2(174, 224)
const PHOTO_FRAME := Vector2(150, 175)
const NOTE_ITEM := Vector2(214, 202)
const SCENE_ITEM := Vector2(226, 182)   # foto de escena (polaroid apaisada)
const OBJECT_ITEM := Vector2(186, 210)  # foto de objeto encontrado (polaroid)
const PIN_R := 8.0

# --- Zoom manual (se aplica ENCIMA del auto-fit) ---
const ZOOM_MIN := 0.6
const ZOOM_MAX := 3.0
const ZOOM_STEP := 0.1

var _viewport: Control              # área clipada que muestra el contenido
var _content_host: Control          # lienzo donde se clavan fotos/notas
var _thread: Line2D                 # hilo rojo decorativo (modo escaparate)
var _pin_points: PackedVector2Array = PackedVector2Array()

# --- Modo jugable: unir parejas de pistas con el hilo ---
const LINK_COL := Color(0.86, 0.16, 0.16, 0.95)   # hilo tendido por el jugador
const LINK_BAD := Color(0.95, 0.55, 0.20, 0.95)   # hilo que no cuaja (se cae)

var _play := false                  # ¿se juega, o es escaparate?
var _links: Array = []              # enlaces del capítulo (Story.links())
var _solved: Dictionary = {}        # índice de pareja -> true (modo parejas)
var _clue_nodes: Dictionary = {}    # título de pista -> {"node": Control, "pin": Vector2}
var _links_layer: Control           # hilos ya tendidos (coords del lienzo)

# --- Modo TRIÁNGULO (pista ↔ persona ↔ zona del mapa) ---
## Cada enlace es una tripleta {clue, who, zone, text}. El jugador tiende TRES hilos
## (pista-persona, persona-zona, pista-zona); cuando la tripleta tiene sus tres lados
## la deducción queda cerrada. Coexiste con el modo parejas: se elige en _ready según
## el esquema del capítulo.
var _triple_mode := false           # el capítulo usa tripletas {clue,who,zone}
var _nodes: Dictionary = {}         # node_key -> {"node":Control,"pin":Vector2,"kind":String,"id":String}
var _tedges: Array = []             # por tripleta: {"cp":bool,"pz":bool,"cz":bool}
var _drag_line: Line2D              # goma elástica del arrastre (coords del viewport)
var _drag_from: String = ""         # título de la pista de la que se arrastra
var _hint: Label                    # instrucción / progreso, bajo el título
var _closing := false               # ya se está cerrando el caso: ignora más entrada
var _solve_btn: Button              # botón de ayuda "Solucionar" (aparece al cabo de 1 min)
var _board_panel: Panel             # el panel corcho (para clavar botones encima)
var _continue_btn: Button           # botón "Continuar" al cerrar el caso (no se cierra solo)

# --- Estado de encaje (auto-fit) + zoom/arrastre manual ---
var _region: Vector2 = Vector2.ZERO     # tamaño visible del viewport
var _grid_size: Vector2 = Vector2.ZERO  # bounding box de la rejilla (sin escala)
var _zoom: float = 1.0
var _pan: Vector2 = Vector2.ZERO
var _dragging: bool = false
var _touches: Dictionary = {}   # index -> pos (pinch de 2 dedos en Android)
var _pinch_base: float = 0.0
var _pinch_zoom0: float = 1.0


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE   # el fondo captura; el panel bloquea

	_links = Story.links()
	_triple_mode = not _links.is_empty() and (_links[0] as Dictionary).has("clue")
	_play = _links_playable()
	_load_solved()

	_build_backdrop()
	_build_board()

	# Fade-in del overlay completo.
	modulate.a = 0.0
	var tw := create_tween()
	tw.tween_property(self, "modulate:a", 1.0, 0.3)


# ---------------------------------------------------------------------------
#  MODO JUGABLE — ¿se puede jugar el tablero de este capítulo?
# ---------------------------------------------------------------------------
## Solo se juega si el capítulo define parejas, el caso sigue abierto y YA están
## descubiertas todas las pistas que intervienen. Mientras falte alguna, el tablero
## es el escaparate de siempre y el texto de ayuda avisa de que falta investigar.
func _links_playable() -> bool:
	if _links.is_empty():
		return false
	if Global.has_flag(Story.end_flag()):
		return false          # el caso ya se cerró: no se vuelve a jugar
	for l in _links:
		if _triple_mode:
			# En modo triángulo basta con tener descubierta la PISTA de cada
			# tripleta; la persona y la zona se muestran siempre como nodos.
			if not _has_clue(String(l["clue"])):
				return false
		elif not _has_clue(String(l["a"])) or not _has_clue(String(l["b"])):
			return false
	return true


## ¿Se ha conocido a este personaje? (met_chars puede ser lista o diccionario).
func _char_met(key: String) -> bool:
	for k in Global.met_chars:
		if String(k) == key:
			return true
	return false


func _has_clue(title: String) -> bool:
	for c in Global.clues:
		if typeof(c) == TYPE_DICTIONARY and String(c.get("title", "")) == title \
				and not bool(c.get("false", false)):
			return true
	return false


## Las parejas ya unidas se recuerdan por bandera: cerrar el tablero a medias (o
## salir del juego) no obliga a rehacerlas.
func _load_solved() -> void:
	if _triple_mode:
		# Solo se persiste la tripleta ENTERA resuelta; los lados a medias no
		# sobreviven a cerrar el tablero (igual que las parejas). Un flag activo
		# -> los tres lados dados por hechos.
		_tedges.resize(_links.size())
		for i in _links.size():
			var done := Global.has_flag(Story.link_flag(i))
			_tedges[i] = {"cp": done, "pz": done, "cz": done}
		return
	for i in _links.size():
		if Global.has_flag(Story.link_flag(i)):
			_solved[i] = true


## Modo triángulo: ¿tiene la tripleta i sus TRES lados tendidos?
func _triple_solved(i: int) -> bool:
	if i < 0 or i >= _tedges.size():
		return false
	var e: Dictionary = _tedges[i]
	return bool(e.get("cp", false)) and bool(e.get("pz", false)) and bool(e.get("cz", false))


## Nº de deducciones cerradas (parejas o tripletas, según el modo).
func _solved_count() -> int:
	if _triple_mode:
		var n := 0
		for i in _links.size():
			if _triple_solved(i):
				n += 1
		return n
	return _solved.size()


## Índice de la pareja formada por estos dos títulos, o -1 si no forman ninguna.
## El orden del arrastre da igual: la pareja no tiene dirección.
func _find_link(a: String, b: String) -> int:
	for i in _links.size():
		var la := String(_links[i]["a"])
		var lb := String(_links[i]["b"])
		if (la == a and lb == b) or (la == b and lb == a):
			return i
	return -1


## ¿Esta pista ya está unida en una pareja resuelta? Las resueltas no se re-arrastran.
func _is_linked(title: String) -> bool:
	for i in _solved:
		if String(_links[i]["a"]) == title or String(_links[i]["b"]) == title:
			return true
	return false


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
	if _closing:
		return          # el caso se está cerrando: que no se lo lleve un clic por delante
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
	# El tablero ocupa TODA la pantalla (margen mínimo para que se vea el marco/sombra).
	var board_size := Vector2(vp.x - 16.0, vp.y - 16.0)

	# CenterContainer a pantalla completa -> el tablero SIEMPRE queda centrado.
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(center)

	var board := Panel.new()
	_board_panel = board
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

	# --- Línea de ayuda / progreso (solo en capítulos con parejas) ---
	var top: float = 66.0
	if not _links.is_empty():
		_hint = Label.new()
		_hint.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
		_hint.clip_text = true
		_hint.add_theme_font_size_override("font_size", 15)
		_hint.add_theme_color_override("font_color", Global.COL_WARM)
		_hint.add_theme_color_override("font_outline_color", Color.BLACK)
		_hint.add_theme_constant_override("outline_size", 5)
		_hint.set_anchors_preset(Control.PRESET_TOP_WIDE)
		_hint.offset_top = 56
		_hint.offset_left = 40
		_hint.offset_right = -40
		board.add_child(_hint)
		_refresh_hint()
		top = 88.0

	# --- Zona de contenido: "viewport" clipado (sin scroll; auto-fit + zoom) ---
	_viewport = Control.new()
	_viewport.clip_contents = true
	_viewport.set_anchors_preset(Control.PRESET_FULL_RECT)
	_viewport.offset_left = 24
	_viewport.offset_right = -24
	_viewport.offset_top = top
	_viewport.offset_bottom = -22
	_viewport.mouse_filter = Control.MOUSE_FILTER_STOP   # captura rueda/arrastre
	_viewport.gui_input.connect(_on_viewport_input)
	board.add_child(_viewport)

	_region = Vector2(board_size.x - 48.0, board_size.y - top - 22.0)

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

	# Hilos tendidos por el jugador: también al fondo, pero por delante del decorativo.
	_links_layer = Control.new()
	_links_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_content_host.add_child(_links_layer)

	_populate(_region.x, _region.y)

	# El HILO siempre por ENCIMA de todo lo clavado: se reordena al frente tras poblar
	# (las fotos/notas/mapa se añaden durante _populate, así que quedarían por delante).
	_content_host.move_child(_thread, -1)
	_content_host.move_child(_links_layer, -1)

	# Goma elástica del arrastre: hija del VIEWPORT (coords sin escalar) y último
	# hijo, así se ve por encima de todo lo clavado mientras se tiende el hilo.
	_drag_line = Line2D.new()
	_drag_line.width = 3.0
	_drag_line.default_color = LINK_COL
	_drag_line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	_drag_line.end_cap_mode = Line2D.LINE_CAP_ROUND
	_drag_line.visible = false
	_viewport.add_child(_drag_line)

	# --- Botones de zoom (+/−) grandes, abajo a la derecha del corcho ---
	_build_zoom_controls(board)

	# Botón de ayuda "Solucionar": aparece al cabo de 1 minuto y cierra el caso solo.
	if _play:
		_build_solve_button(board)


# ---------------------------------------------------------------------------
#  CONTENIDO DINÁMICO
# ---------------------------------------------------------------------------
func _populate(content_w: float, region_h: float) -> void:
	# Modo triángulo: composición propia (personas arriba, pistas a la izquierda,
	# mapa del barrio a la derecha con un pin por zona).
	if _triple_mode:
		_populate_triples(content_w, region_h)
		return

	# Recopila lo que se clava: fotos de personajes + fotos de ESCENAS clave visitadas
	# + fotos de OBJETOS encontrados (si hay imagen) o notas de pista.
	var items: Array = []
	for k in Global.met_chars:
		var key := String(k)
		if not Story.CHARS.has(key):
			continue
		items.append({"node": _make_photo(key), "crossed": false})
	# Escenas clave: localizaciones ya visitadas del capítulo actual (con su fondo).
	for loc in Story.locations():
		var id := String(loc.id)
		if Global.has_flag("done_" + id):
			var d: Dictionary = Story.get_dialogue(id)
			var bg := String(d.get("bg", ""))
			if bg != "" and Story.BGS.has(bg):
				items.append({"node": _make_scene_photo(bg, String(loc.get("name", ""))), "crossed": false})
	# Pistas: si existe la foto del objeto -> polaroid del objeto; si no -> nota de papel.
	for c in Global.clues:
		if typeof(c) != TYPE_DICTIONARY:
			continue
		var is_false: bool = bool(c.get("false", false))
		var obj := _object_image_for(c)
		# Las falsas van al montón de descartadas: sin pin propio (lo comparten).
		var node: Control = _make_object_photo(c, obj, is_false, not is_false) if obj != "" \
			else _make_note(c, is_false, not is_false)
		# El título marca las pistas VERDADERAS como enganche del hilo (ver _clue_at).
		items.append({"node": node, "crossed": is_false,
			"clue": "" if is_false else String(c.get("title", ""))})

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

	# Lo bueno se reparte por la rejilla (mezclado: fotos, escenas, objetos, notas).
	# Lo DESCARTADO no: va amontonado en la esquina inferior izquierda (ver _stack_discarded).
	var kept: Array = []
	var discarded: Array = []
	for it in items:
		if bool(it["crossed"]):
			discarded.append(it)
		else:
			kept.append(it)
	kept.shuffle()
	discarded.shuffle()

	# La rejilla la dimensiona solo lo clavado: el montón entero gasta UNA celda.
	var cols: int = maxi(1, int(ceil(sqrt(float(maxi(kept.size(), 1))))))
	cols = mini(cols, maxi(kept.size(), 1))
	var rows_kept: int = int(ceil(float(kept.size()) / float(cols)))
	var rows: int = rows_kept + (1 if not discarded.is_empty() else 0)
	var grid_w: float = float(cols) * CELL.x
	var grid_h: float = float(rows) * CELL.y

	var pins: Array = []   # {pos} de la chincheta (ya rotada) de cada elemento clavado
	for i in kept.size():
		var node: Control = kept[i]["node"]
		var cell_origin := Vector2(float(i % cols) * CELL.x, float(i / cols) * CELL.y)
		# Colocación orgánica: desplazamiento amplio dentro de la celda + rotación marcada.
		var jitter := Vector2(randf_range(-22.0, 22.0), randf_range(-18.0, 18.0))
		node.position = cell_origin + (CELL - node.size) * 0.5 + jitter
		node.pivot_offset = node.size * 0.5
		node.rotation_degrees = randf_range(-7.0, 7.0)
		_content_host.add_child(node)
		var cen := node.position + node.size * 0.5
		var pin_at: Vector2 = cen + Vector2(0.0, PIN_R + 4.0 - node.size.y * 0.5).rotated(node.rotation)
		pins.append({"pos": pin_at})
		# Las pistas verdaderas quedan indexadas por título: son de donde y hacia
		# donde se tiende el hilo, y su chincheta es el punto de anclaje.
		var title := String(kept[i].get("clue", ""))
		if title != "":
			_clue_nodes[title] = {"node": node, "pin": pin_at}

	# El montón de descartadas, en fila nueva bajo la rejilla y pegado a la izquierda.
	if not discarded.is_empty():
		_stack_discarded(discarded, Vector2(0.0, float(rows_kept) * CELL.y))

	# El lienzo mide EXACTAMENTE el bounding box de la rejilla; su centro es el pivote.
	_grid_size = Vector2(grid_w, grid_h)
	_content_host.size = _grid_size
	_content_host.custom_minimum_size = _grid_size
	_content_host.pivot_offset = _grid_size * 0.5

	# El hilo decorativo solo se teje en modo escaparate: si se juega, el único hilo
	# que se ve es el que tiende el jugador (si no, no se distinguiría uno de otro).
	if _play:
		_redraw_solved_links()
	else:
		_pin_points = _thread_nearest(pins)
		if _pin_points.size() >= 2:
			_thread.points = _pin_points

	_apply_transform()


## Amontona las pistas descartadas en una sola celda: todas comparten el centro,
## unas encima de otras (la última queda arriba), y las clava un ÚNICO pin puesto
## en el borde superior de la de encima. El desorden lo dan un desplazamiento corto
## y un giro marcado por tarjeta, para que se vea que es un montón y no una sola.
func _stack_discarded(discarded: Array, cell_origin: Vector2) -> void:
	for it in discarded:
		var node: Control = it["node"]
		var jitter := Vector2(randf_range(-9.0, 9.0), randf_range(-7.0, 7.0))
		node.position = cell_origin + (CELL - node.size) * 0.5 + jitter
		node.pivot_offset = node.size * 0.5
		node.rotation_degrees = randf_range(-12.0, 12.0)
		_content_host.add_child(node)   # cada una tapa a la anterior

	# El pin va al final -> se dibuja por encima de todo el montón.
	var top: Control = discarded[discarded.size() - 1]["node"]
	var cen := top.position + top.size * 0.5
	var pin_at := cen + Vector2(0.0, PIN_R + 4.0 - top.size.y * 0.5).rotated(top.rotation)
	var pin := _make_pin(PIN_R)
	pin.position = pin_at - Vector2(PIN_R, PIN_R)   # centrar el círculo en pin_at
	_content_host.add_child(pin)


## Ordena las chinchetas por vecino más próximo para que el hilo TEJA el tablero
## (en vez de recorrerlo por filas). Recibe solo lo clavado: las descartadas
## están amontonadas aparte y el hilo no las toca.
func _thread_nearest(pins: Array) -> PackedVector2Array:
	var pts: Array = []
	for p in pins:
		pts.append(p["pos"] as Vector2)
	if pts.size() < 2:
		return PackedVector2Array(pts)
	var path: Array = [pts.pop_front()]
	while not pts.is_empty():
		var last: Vector2 = path[path.size() - 1]
		var bi: int = 0
		var bd: float = INF
		for i in pts.size():
			var d: float = last.distance_squared_to(pts[i])
			if d < bd:
				bd = d
				bi = i
		path.append(pts.pop_at(bi))
	return PackedVector2Array(path)


# ---------------------------------------------------------------------------
#  MODO TRIÁNGULO — composición (personas / pistas / mapa) y lógica de lados
# ---------------------------------------------------------------------------
## Conjunto (título -> true) de TODAS las pistas que pertenecen al capítulo actual:
## las de las tripletas, las "de calle" y las que sueltan las localizaciones. Sirve
## para que el tablero muestre solo las pistas de este capítulo, no las acumuladas.
func _chapter_clue_titles() -> Dictionary:
	var titles := {}
	for t in _links:
		if typeof(t) == TYPE_DICTIONARY:
			var ct := String(t.get("clue", ""))
			if ct != "":
				titles[ct] = true
	for st in Story.street_clues():
		titles[String(st)] = true
	for loc in Story.locations():
		var d: Dictionary = Story.get_dialogue(String(loc.get("id", "")))
		if d.has("clue") and typeof(d["clue"]) == TYPE_DICTIONARY:
			titles[String((d["clue"] as Dictionary).get("title", ""))] = true
		if d.has("clues"):
			for c in d["clues"]:
				if typeof(c) == TYPE_DICTIONARY:
					titles[String(c.get("title", ""))] = true
	titles.erase("")
	return titles


## Compone el tablero a 3 bandas: fila de PERSONAS arriba, columna de PISTAS a la
## izquierda y el MAPA del barrio a la derecha con un pin por zona. Registra cada
## elemento en _nodes con su chincheta (coords del lienzo) para tender los hilos.
func _populate_triples(content_w: float, region_h: float) -> void:
	_nodes.clear()
	var GAP := 28.0
	var MAP_W := 940.0
	var MAP_H := 720.0

	# Personas: las ya conocidas + las que citan las tripletas (sin el narrador).
	var person_keys: Array = []
	var seen: Dictionary = {}
	for k in Global.met_chars:
		var kk := String(k)
		if kk != "" and kk != "narrador" and Story.CHARS.has(kk) and not seen.has(kk):
			seen[kk] = true
			person_keys.append(kk)
	for l in _links:
		var w := String(l.get("who", ""))
		if w != "" and w != "narrador" and Story.CHARS.has(w) and not seen.has(w):
			seen[w] = true
			person_keys.append(w)

	# Pistas verdaderas descubiertas que PERTENECEN A ESTE CAPÍTULO (objeto con foto ->
	# polaroid; si no -> nota). Se filtra por el conjunto real de pistas del capítulo
	# (calculado de Story), no por la etiqueta del save: así no se cuelan las de otros
	# capítulos aunque la partida sea vieja.
	var chapter_titles := _chapter_clue_titles()
	var clue_list: Array = []
	for c in Global.clues:
		if typeof(c) != TYPE_DICTIONARY or bool(c.get("false", false)):
			continue
		if not chapter_titles.has(String(c.get("title", ""))):
			continue
		clue_list.append(c)

	# --- Fila de personas arriba ---
	var px := 0.0
	var person_h := PHOTO_ITEM.y
	for key in person_keys:
		var node := _make_photo(key)
		node.position = Vector2(px, 0.0)
		node.pivot_offset = node.size * 0.5
		_content_host.add_child(node)
		_register_node("person:" + key, node, "person", key,
			Vector2(px + PHOTO_ITEM.x * 0.5, PIN_R + 2.0))
		px += PHOTO_ITEM.x + 14.0
	var persons_w := maxf(px - 14.0, 0.0)

	var col_top := person_h + GAP

	# --- Pistas con FOTO (polaroids de objeto) a la IZQUIERDA ---
	var photo_w := 0.0
	var py := col_top
	for c in clue_list:
		var obj := _object_image_for(c)
		if obj == "":
			continue
		var pnode := _make_object_photo(c, obj, false, true)
		pnode.position = Vector2(0.0, py)
		pnode.pivot_offset = pnode.size * 0.5
		_content_host.add_child(pnode)
		_register_node("clue:" + String(c.get("title", "")), pnode, "clue",
			String(c.get("title", "")), Vector2(pnode.size.x * 0.5, py + PIN_R + 2.0))
		py += pnode.size.y + 16.0
		photo_w = maxf(photo_w, pnode.size.x)
	var photo_h := py - col_top

	# --- Mapa del barrio en el CENTRO, con los pines de zona ---
	var map_x := photo_w + (GAP if photo_w > 0.0 else 0.0)
	var map := _make_board_map(MAP_W, MAP_H)
	map.position = Vector2(map_x, col_top)
	map.pivot_offset = Vector2(MAP_W, MAP_H) * 0.5
	_content_host.add_child(map)
	_place_zone_markers(Vector2(map_x, col_top), MAP_W, MAP_H)

	# --- NOTAS escritas (papel) a la DERECHA ---
	var note_x := map_x + MAP_W + GAP
	var note_w := 0.0
	var ny := col_top
	for c in clue_list:
		if _object_image_for(c) != "":
			continue
		var nnode := _make_note(c, false, true)
		nnode.position = Vector2(note_x, ny)
		nnode.pivot_offset = nnode.size * 0.5
		_content_host.add_child(nnode)
		_register_node("clue:" + String(c.get("title", "")), nnode, "clue",
			String(c.get("title", "")), Vector2(note_x + nnode.size.x * 0.5, ny + PIN_R + 2.0))
		ny += nnode.size.y + 16.0
		note_w = maxf(note_w, nnode.size.x)
	var note_h := ny - col_top

	# --- Tamaño del lienzo = caja que envuelve todo ---
	var total_w := maxf(persons_w, note_x + note_w)
	var total_h := person_h + GAP + maxf(maxf(photo_h, MAP_H), note_h)
	_grid_size = Vector2(maxf(total_w, 1.0), maxf(total_h, 1.0))
	_content_host.size = _grid_size
	_content_host.custom_minimum_size = _grid_size
	_content_host.pivot_offset = _grid_size * 0.5

	if _play:
		_redraw_triangles()
	_apply_transform()


func _register_node(key: String, node: Control, kind: String, id: String, pin: Vector2) -> void:
	_nodes[key] = {"node": node, "pin": pin, "kind": kind, "id": id}


## Coloca un marcador (chincheta + nombre) por cada localización del capítulo sobre
## el mapa, usando su `pos` (fracción 0..1). Los marcadores cuelgan del lienzo (no
## del mapa) para que su transform sea el mismo espacio que el resto de nodos.
func _place_zone_markers(map_pos: Vector2, w: float, h: float) -> void:
	var inset := Vector2(10.0, 10.0)
	var inner := Vector2(w - 20.0, h - 50.0)   # área de la foto del mapa (ver _make_board_map)
	for loc in Story.locations():
		var id := String(loc.get("id", ""))
		if id == "":
			continue
		var frac: Vector2 = loc.get("pos", Vector2(0.5, 0.5))
		var local := inset + Vector2(frac.x * inner.x, frac.y * inner.y)
		var marker := _make_zone_marker(String(loc.get("name", "")))
		marker.position = map_pos + local - marker.size * 0.5
		_content_host.add_child(marker)
		_register_node("zone:" + id, marker, "zone", id, map_pos + local)


## Nodo enganchable bajo ese punto del lienzo (pista/persona/zona), o "" si no hay.
## Gana el ÚLTIMO añadido (el que se ve encima si dos se solapan).
func _node_at(p: Vector2) -> String:
	var hit := ""
	for key in _nodes:
		var node: Control = _nodes[key]["node"]
		if not is_instance_valid(node):
			continue
		if Rect2(Vector2.ZERO, node.size).has_point(node.get_transform().affine_inverse() * p):
			hit = String(key)
	return hit


## Intenta tender un lado del triángulo entre dos nodos. Si son de tipos distintos y
## pertenecen a una MISMA tripleta sin resolver, el lado se queda; si con él la
## tripleta ya tiene sus tres lados, la deducción se cierra.
func _try_triangle_edge(a: String, b: String) -> void:
	if not _nodes.has(a) or not _nodes.has(b):
		return
	var ka := String(_nodes[a]["kind"])
	var kb := String(_nodes[b]["kind"])
	if ka == kb:
		_flash_hint(Global.loc("Une elementos distintos: pista, persona y zona."), Global.COL_ACCENT, 1.4)
		return
	var clue_id := ""
	var person_id := ""
	var zone_id := ""
	for pair in [[ka, String(_nodes[a]["id"])], [kb, String(_nodes[b]["id"])]]:
		match String(pair[0]):
			"clue": clue_id = String(pair[1])
			"person": person_id = String(pair[1])
			"zone": zone_id = String(pair[1])
	var side := ""
	if clue_id != "" and person_id != "":
		side = "cp"
	elif person_id != "" and zone_id != "":
		side = "pz"
	elif clue_id != "" and zone_id != "":
		side = "cz"
	if side == "":
		return
	for i in _links.size():
		if _triple_solved(i):
			continue
		var t: Dictionary = _links[i]
		var tc := String(t.get("clue", ""))
		var tw := String(t.get("who", ""))
		var tz := String(t.get("zone", ""))
		var ok := false
		match side:
			"cp": ok = clue_id == tc and person_id == tw
			"pz": ok = person_id == tw and zone_id == tz
			"cz": ok = clue_id == tc and zone_id == tz
		if ok:
			if bool(_tedges[i].get(side, false)):
				return              # ese lado ya estaba
			_tedges[i][side] = true
			Global.play_sfx(Global.SFX_CLICK, -6.0)
			_redraw_triangles()
			if _triple_solved(i):
				_on_triple_solved(i)
			else:
				_flash_hint(Global.loc("Un lado menos. Cierra el triángulo."), Global.COL_WARM, 1.2)
			return
	_on_edge_wrong(a, b)


func _on_triple_solved(i: int) -> void:
	Global.set_flag(Story.link_flag(i), true)
	Global.play_sfx(Global.SFX_CONFIRM, -4.0)
	_redraw_triangles()
	if _solved_count() >= _links.size():
		_close_case()
	else:
		_flash_hint(Global.loc(String(_links[i].get("text", ""))), Global.COL_WARM, 2.6)


## Lado que no cuadra: se tiende un instante en ámbar y se cae, sin penalización.
func _on_edge_wrong(a: String, b: String) -> void:
	Global.play_sfx(Global.SFX_BACK, -8.0)
	var l := _make_thread_line(LINK_BAD)
	l.points = PackedVector2Array([_pin_of(a), _pin_of(b)])
	_links_layer.add_child(l)
	var t := create_tween()
	t.tween_property(l, "modulate:a", 0.0, 0.45)
	t.tween_callback(l.queue_free)
	_flash_hint(Global.loc("Ese hilo no se sostiene."), Global.COL_ACCENT, 1.4)


## Redibuja TODOS los lados ya tendidos de todas las tripletas.
func _redraw_triangles() -> void:
	if _links_layer == null:
		return
	for c in _links_layer.get_children():
		c.queue_free()
	for i in _links.size():
		if i >= _tedges.size():
			continue
		var t: Dictionary = _links[i]
		var ck := "clue:" + String(t.get("clue", ""))
		var pk := "person:" + String(t.get("who", ""))
		var zk := "zone:" + String(t.get("zone", ""))
		var e: Dictionary = _tedges[i]
		if bool(e.get("cp", false)):
			_add_solid_edge(ck, pk)
		if bool(e.get("pz", false)):
			_add_solid_edge(pk, zk)
		if bool(e.get("cz", false)):
			_add_solid_edge(ck, zk)


func _add_solid_edge(a: String, b: String) -> void:
	if not _nodes.has(a) or not _nodes.has(b):
		return
	var l := _make_thread_line(LINK_COL)
	l.points = PackedVector2Array([_pin_of(a), _pin_of(b)])
	_links_layer.add_child(l)


## Panel del mapa del barrio (marco crema + foto del mapa del capítulo + rótulo).
func _make_board_map(w: float, h: float) -> Control:
	var item := Control.new()
	item.custom_minimum_size = Vector2(w, h)
	item.size = Vector2(w, h)
	item.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var card := Panel.new()
	card.size = Vector2(w, h)
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var csb := StyleBoxFlat.new()
	csb.bg_color = COL_CREAM
	csb.set_corner_radius_all(3)
	csb.set_border_width_all(1)
	csb.border_color = Color(0.74, 0.71, 0.61)
	csb.shadow_color = Color(0, 0, 0, 0.55)
	csb.shadow_size = 10
	csb.shadow_offset = Vector2(3, 5)
	card.add_theme_stylebox_override("panel", csb)
	item.add_child(card)

	var photo := Panel.new()
	photo.clip_contents = true
	photo.position = Vector2(10, 10)
	photo.size = Vector2(w - 20, h - 50)
	photo.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var pbg := StyleBoxFlat.new()
	pbg.bg_color = Color(0.09, 0.10, 0.12)
	photo.add_theme_stylebox_override("panel", pbg)
	card.add_child(photo)

	var map_path := Story.chapter_map()
	if ResourceLoader.exists(map_path):
		var tex := TextureRect.new()
		tex.set_anchors_preset(Control.PRESET_FULL_RECT)
		tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		tex.texture = load(map_path)
		tex.mouse_filter = Control.MOUSE_FILTER_IGNORE
		photo.add_child(tex)

	var cap := Label.new()
	cap.text = Global.loc("El barrio")
	cap.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
	cap.clip_text = true
	cap.position = Vector2(6, h - 28)
	cap.size = Vector2(w - 12, 24)
	cap.add_theme_font_size_override("font_size", 14)
	cap.add_theme_color_override("font_color", COL_INK)
	cap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(cap)
	return item


## Marcador de zona: chincheta ámbar + nombre al lado. Toque generoso (34x34).
func _make_zone_marker(zone_name: String) -> Control:
	var m := Control.new()
	m.size = Vector2(34, 34)
	m.custom_minimum_size = Vector2(34, 34)
	m.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var d := 16.0
	var dot := Panel.new()
	dot.size = Vector2(d, d)
	dot.position = Vector2((34.0 - d) * 0.5, (34.0 - d) * 0.5)
	dot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sb := StyleBoxFlat.new()
	sb.bg_color = Global.COL_WARM
	sb.set_corner_radius_all(int(d * 0.5))
	sb.set_border_width_all(2)
	sb.border_color = Color(0.20, 0.12, 0.05)
	sb.shadow_color = Color(0, 0, 0, 0.6)
	sb.shadow_size = 5
	dot.add_theme_stylebox_override("panel", sb)
	m.add_child(dot)

	var lbl := Label.new()
	lbl.text = Global.loc(zone_name)
	lbl.clip_text = true
	lbl.position = Vector2(18, -4)
	lbl.size = Vector2(130, 22)
	lbl.add_theme_font_size_override("font_size", 12)
	lbl.add_theme_color_override("font_color", COL_CREAM)
	lbl.add_theme_color_override("font_outline_color", Color.BLACK)
	lbl.add_theme_constant_override("outline_size", 4)
	lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	m.add_child(lbl)
	return m


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
			# Empezar sobre una pista tiende hilo; sobre el corcho, arrastra el tablero.
			if event.pressed:
				_dragging = not _begin_link_drag(event.position)
			else:
				if _drag_from != "":
					_end_link_drag(event.position)
				_dragging = false
			_viewport.accept_event()
	elif event is InputEventMouseMotion:
		if _drag_from != "":
			_update_drag_line(event.position)
		elif _dragging:
			_pan += event.relative
			_apply_transform()
	elif event is InputEventScreenTouch:
		if event.pressed:
			_touches[event.index] = event.position
		else:
			_touches.erase(event.index)
		if _touches.size() >= 2:
			_cancel_link_drag()   # dos dedos son un pinch, no un hilo
			_pinch_base = _pinch_distance()
			_pinch_zoom0 = _zoom
		elif event.pressed and _touches.size() == 1:
			_begin_link_drag(event.position)
		elif not event.pressed and _drag_from != "":
			_end_link_drag(event.position)
		_dragging = _touches.size() == 1 and _drag_from == ""
		_viewport.accept_event()
	elif event is InputEventScreenDrag:
		_touches[event.index] = event.position
		if _touches.size() >= 2:
			# Pinch: la separación de los dos dedos escala el zoom (paso continuo).
			var d := _pinch_distance()
			if _pinch_base > 1.0:
				_zoom = clampf(_pinch_zoom0 * (d / _pinch_base), ZOOM_MIN, ZOOM_MAX)
				_apply_transform()
		elif _drag_from != "":
			_update_drag_line(event.position)
		elif _dragging:
			_pan += event.relative
			_apply_transform()
		_viewport.accept_event()


# ---------------------------------------------------------------------------
#  TENDER EL HILO (modo jugable)
# ---------------------------------------------------------------------------
## Punto del viewport -> coordenadas del lienzo, deshaciendo el auto-fit, el zoom
## y el arrastre de una vez (get_transform() ya incluye posición, escala y pivote).
func _content_point(vp_pos: Vector2) -> Vector2:
	return _content_host.get_transform().affine_inverse() * vp_pos


## Título de la pista que hay bajo ese punto del lienzo, o "" si es corcho desnudo.
## Cada tarjeta va rotada, así que el punto se lleva al espacio local de cada una.
## Gana la ÚLTIMA clavada: es la que se ve encima si dos se solapan.
func _clue_at(p: Vector2) -> String:
	var hit := ""
	for title in _clue_nodes:
		var node: Control = _clue_nodes[title]["node"]
		if not is_instance_valid(node):
			continue
		if Rect2(Vector2.ZERO, node.size).has_point(node.get_transform().affine_inverse() * p):
			hit = String(title)
	return hit


## Intenta empezar a tender hilo desde la pista que haya bajo el punto.
## Devuelve false si no se juega o ahí no hay pista libre: entonces el gesto es un
## arrastre del tablero, como siempre.
func _begin_link_drag(vp_pos: Vector2) -> bool:
	if not _play or _closing:
		return false
	if _triple_mode:
		# Cualquier nodo (pista, persona o zona) puede ser origen del hilo; la
		# validez del lado se comprueba al soltar.
		var key := _node_at(_content_point(vp_pos))
		if key == "":
			return false
		_drag_from = key
		_update_drag_line(vp_pos)
		Global.play_sfx(Global.SFX_CLICK, -14.0)
		return true
	var title := _clue_at(_content_point(vp_pos))
	if title == "" or _is_linked(title):
		return false        # las pistas ya unidas no se vuelven a tocar
	_drag_from = title
	_update_drag_line(vp_pos)
	Global.play_sfx(Global.SFX_CLICK, -14.0)
	return true


func _update_drag_line(vp_pos: Vector2) -> void:
	if _drag_from == "" or _drag_line == null or not _has_link_node(_drag_from):
		return
	# El origen es la chincheta (en coords del lienzo); la goma vive en el viewport.
	var from: Vector2 = _content_host.get_transform() * _pin_of(_drag_from)
	_drag_line.points = PackedVector2Array([from, vp_pos])
	_drag_line.visible = true


## Chincheta (coords del lienzo) de un nodo enganchable, sea pista (modo parejas)
## o nodo genérico pista/persona/zona (modo triángulo).
func _pin_of(key: String) -> Vector2:
	if _triple_mode:
		return (_nodes[key]["pin"] as Vector2) if _nodes.has(key) else Vector2.ZERO
	return (_clue_nodes[key]["pin"] as Vector2) if _clue_nodes.has(key) else Vector2.ZERO


func _has_link_node(key: String) -> bool:
	return _nodes.has(key) if _triple_mode else _clue_nodes.has(key)


func _cancel_link_drag() -> void:
	_drag_from = ""
	if _drag_line != null:
		_drag_line.visible = false


func _end_link_drag(vp_pos: Vector2) -> void:
	var from := _drag_from
	_cancel_link_drag()
	if from == "" or _closing:
		return
	if _triple_mode:
		var tkey := _node_at(_content_point(vp_pos))
		if tkey == "" or tkey == from:
			return
		_try_triangle_edge(from, tkey)
		return
	var to := _clue_at(_content_point(vp_pos))
	if to == "" or to == from or _is_linked(to):
		return              # soltado en el vacío o sobre algo que no cuenta: sin castigo
	var idx := _find_link(from, to)
	if idx < 0:
		_on_link_wrong(from, to)
	else:
		_on_link_right(idx)


## Pareja correcta: el hilo se queda clavado, se recuerda y se canta la deducción.
func _on_link_right(idx: int) -> void:
	_solved[idx] = true
	Global.set_flag(Story.link_flag(idx), true)
	Global.play_sfx(Global.SFX_CONFIRM, -4.0)
	_redraw_solved_links()
	if _solved.size() >= _links.size():
		_close_case()
	else:
		_flash_hint(Global.loc(String(_links[idx].get("text", ""))), Global.COL_WARM, 2.4)


## Pareja que no cuadra: el hilo se tiende un instante en ámbar y se cae. Sin
## penalización: equivocarse es parte de pensar (mismo criterio que DeduceView).
func _on_link_wrong(from: String, to: String) -> void:
	Global.play_sfx(Global.SFX_BACK, -8.0)
	var l := _make_thread_line(LINK_BAD)
	l.points = PackedVector2Array([_clue_nodes[from]["pin"], _clue_nodes[to]["pin"]])
	_links_layer.add_child(l)
	var t := create_tween()
	t.tween_property(l, "modulate:a", 0.0, 0.45)
	t.tween_callback(l.queue_free)
	_flash_hint(Global.loc("Ese hilo no se sostiene."), Global.COL_ACCENT, 1.4)


func _make_thread_line(col: Color) -> Line2D:
	var l := Line2D.new()
	l.width = 3.0
	l.default_color = col
	l.begin_cap_mode = Line2D.LINE_CAP_ROUND
	l.end_cap_mode = Line2D.LINE_CAP_ROUND
	l.joint_mode = Line2D.LINE_JOINT_ROUND
	return l


## Redibuja los hilos ya ganados. Se llama al poblar (las tarjetas se recolocan en
## cada apertura, así que las coordenadas de ayer no valen) y al unir una pareja.
func _redraw_solved_links() -> void:
	if _links_layer == null:
		return
	if _triple_mode:
		_redraw_triangles()
		return
	for c in _links_layer.get_children():
		c.queue_free()
	for i in _solved:
		var a := String(_links[i]["a"])
		var b := String(_links[i]["b"])
		if not _clue_nodes.has(a) or not _clue_nodes.has(b):
			continue
		var l := _make_thread_line(LINK_COL)
		l.points = PackedVector2Array([_clue_nodes[a]["pin"], _clue_nodes[b]["pin"]])
		_links_layer.add_child(l)


# ---------------------------------------------------------------------------
#  AYUDA / PROGRESO + CIERRE DEL CASO
# ---------------------------------------------------------------------------
func _refresh_hint() -> void:
	if _hint == null:
		return
	if Global.has_flag(Story.end_flag()):
		_hint.text = Global.loc("Caso cerrado.")
		_hint.add_theme_color_override("font_color", Color(0.6, 0.9, 0.65))
	elif not _play:
		_hint.text = Global.loc("Faltan pistas por encontrar. Sigue investigando.")
		_hint.add_theme_color_override("font_color", Global.COL_TEXT)
	elif _triple_mode:
		_hint.text = Global.loc("Une cada PISTA con su PERSONA y su ZONA del mapa.  (%d/%d)") \
			% [_solved_count(), _links.size()]
		_hint.add_theme_color_override("font_color", Global.COL_WARM)
	else:
		_hint.text = Global.loc("Une con un hilo las pistas que se sostengan.  (%d/%d)") \
			% [_solved_count(), _links.size()]
		_hint.add_theme_color_override("font_color", Global.COL_WARM)


## Mensaje pasajero en la línea de ayuda (deducción ganada o hilo rechazado); al
## expirar vuelve el progreso.
func _flash_hint(msg: String, col: Color, secs: float) -> void:
	if _hint == null:
		return
	_hint.text = msg
	_hint.add_theme_color_override("font_color", col)
	await get_tree().create_timer(secs).timeout
	if is_instance_valid(_hint) and not _closing:
		_refresh_hint()


## Todas las parejas unidas: el caso queda cerrado. Se marca la bandera del tablero
## (que es el requisito de la localización de cierre, así que ya no se puede saltar)
## y se avisa a CityMap, que encadena el epílogo; ese diálogo activa end_flag y con
## él el salto de capítulo. El tablero no avanza nada por su cuenta.
func _close_case() -> void:
	_closing = true
	_cancel_link_drag()
	var f := Story.links_flag()
	if f != "":
		Global.set_flag(f, true)
	if _hint != null:
		_hint.text = Global.loc("Todo encaja. El caso está cerrado.")
		_hint.add_theme_color_override("font_color", Color(0.6, 0.9, 0.65))
	# El botón de ayuda ya no hace falta; el jugador cierra con "Continuar".
	if is_instance_valid(_solve_btn):
		_solve_btn.visible = false
	# NO se cierra solo: aparece un botón "Continuar" que emite el cierre al pulsarlo.
	_show_continue_button()


## Botón "Continuar" al resolver el tablero: el jugador decide cuándo seguir; al
## pulsarlo se emite case_closed (epílogo/comisaría) y se cierra el tablero.
func _show_continue_button() -> void:
	if is_instance_valid(_continue_btn) or _board_panel == null:
		return
	Global.play_sfx(Global.SFX_CONFIRM, -6.0)
	_continue_btn = Button.new()
	_continue_btn.text = Global.loc("Continuar")
	_continue_btn.focus_mode = Control.FOCUS_NONE
	_continue_btn.mouse_filter = Control.MOUSE_FILTER_STOP
	_continue_btn.add_theme_font_size_override("font_size", 20)
	_continue_btn.add_theme_color_override("font_color", COL_CREAM)
	_continue_btn.add_theme_color_override("font_outline_color", Color.BLACK)
	_continue_btn.add_theme_constant_override("outline_size", 4)
	var mk := func(bg: Color) -> StyleBoxFlat:
		var sb := StyleBoxFlat.new()
		sb.bg_color = bg
		sb.set_corner_radius_all(10)
		sb.set_border_width_all(2)
		sb.border_color = Color(0.55, 0.85, 0.60)   # verde "resuelto"
		sb.content_margin_left = 28
		sb.content_margin_right = 28
		sb.content_margin_top = 12
		sb.content_margin_bottom = 12
		return sb
	_continue_btn.add_theme_stylebox_override("normal", mk.call(Color(0.10, 0.16, 0.11, 0.98)))
	_continue_btn.add_theme_stylebox_override("hover", mk.call(Color(0.14, 0.22, 0.15, 1.0)))
	_continue_btn.add_theme_stylebox_override("pressed", mk.call(Color(0.18, 0.28, 0.18, 1.0)))
	_continue_btn.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	_continue_btn.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_continue_btn.grow_vertical = Control.GROW_DIRECTION_BEGIN
	_continue_btn.offset_bottom = -26
	_board_panel.add_child(_continue_btn)
	_continue_btn.pressed.connect(_on_continue_pressed)
	# Pequeña entrada (aparece con un fundido/escala).
	_continue_btn.modulate.a = 0.0
	_continue_btn.pivot_offset = _continue_btn.size * 0.5
	var tw := create_tween()
	tw.tween_property(_continue_btn, "modulate:a", 1.0, 0.35)


func _on_continue_pressed() -> void:
	if not is_inside_tree():
		return
	case_closed.emit()
	_close()


# ---------------------------------------------------------------------------
#  CONTROLES DE ZOOM (+/−)
# ---------------------------------------------------------------------------
func _build_zoom_controls(board: Panel) -> void:
	var box := VBoxContainer.new()
	box.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	box.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	box.grow_vertical = Control.GROW_DIRECTION_BEGIN
	box.offset_left = -64
	box.offset_top = -108
	box.offset_right = -20
	box.offset_bottom = -20
	box.add_theme_constant_override("separation", 8)
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	board.add_child(box)

	var b_plus := _make_zoom_button("+")
	b_plus.pressed.connect(func() -> void: _add_zoom(ZOOM_STEP))
	box.add_child(b_plus)

	var b_minus := _make_zoom_button("−")
	b_minus.pressed.connect(func() -> void: _add_zoom(-ZOOM_STEP))
	box.add_child(b_minus)


## Botón "Solucionar" (ayuda): oculto al abrir, aparece al cabo de 1 minuto. Al
## pulsarlo cierra el caso automáticamente (marca todas las deducciones y cierra).
func _build_solve_button(board: Panel) -> void:
	_solve_btn = Button.new()
	_solve_btn.text = Global.loc("Solucionar")
	_solve_btn.focus_mode = Control.FOCUS_NONE
	_solve_btn.mouse_filter = Control.MOUSE_FILTER_STOP
	_solve_btn.visible = false                 # aparece tras 1 minuto
	_solve_btn.add_theme_font_size_override("font_size", 16)
	_solve_btn.add_theme_color_override("font_color", COL_CREAM)
	_solve_btn.add_theme_color_override("font_outline_color", Color.BLACK)
	_solve_btn.add_theme_constant_override("outline_size", 4)
	var mk := func(bg: Color) -> StyleBoxFlat:
		var sb := StyleBoxFlat.new()
		sb.bg_color = bg
		sb.set_corner_radius_all(8)
		sb.set_border_width_all(2)
		sb.border_color = Global.COL_ACCENT
		sb.content_margin_left = 14
		sb.content_margin_right = 14
		sb.content_margin_top = 8
		sb.content_margin_bottom = 8
		return sb
	_solve_btn.add_theme_stylebox_override("normal", mk.call(Color(0.14, 0.10, 0.07, 0.96)))
	_solve_btn.add_theme_stylebox_override("hover", mk.call(Color(0.22, 0.14, 0.09, 1.0)))
	_solve_btn.add_theme_stylebox_override("pressed", mk.call(Color(0.28, 0.16, 0.10, 1.0)))
	_solve_btn.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	_solve_btn.grow_vertical = Control.GROW_DIRECTION_BEGIN
	_solve_btn.offset_left = 20
	_solve_btn.offset_bottom = -20
	board.add_child(_solve_btn)
	_solve_btn.pressed.connect(_solve_all)
	# Temporizador de 1 minuto -> revela el botón.
	get_tree().create_timer(60.0).timeout.connect(_reveal_solve_button)


func _reveal_solve_button() -> void:
	if is_instance_valid(_solve_btn) and not _closing:
		_solve_btn.visible = true
		Global.play_sfx(Global.SFX_NOTE, -10.0)


## Cierra el caso solo: da por tendidos todos los hilos (tripletas o parejas),
## los redibuja y encadena el cierre igual que si el jugador los hubiera unido.
func _solve_all() -> void:
	if _closing:
		return
	if _triple_mode:
		for i in _links.size():
			_tedges[i] = {"cp": true, "pz": true, "cz": true}
			Global.set_flag(Story.link_flag(i), true)
		_redraw_triangles()
	else:
		for i in _links.size():
			_solved[i] = true
			Global.set_flag(Story.link_flag(i), true)
		_redraw_solved_links()
	Global.play_sfx(Global.SFX_CONFIRM, -4.0)
	_close_case()


func _make_zoom_button(txt: String) -> Button:
	var b := Button.new()
	b.text = txt
	b.custom_minimum_size = Vector2(44, 40)
	b.focus_mode = Control.FOCUS_NONE
	b.mouse_filter = Control.MOUSE_FILTER_STOP
	b.add_theme_font_size_override("font_size", 22)
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
## `with_pin` = false para las pistas descartadas: van apiladas y las clava un
## único pin común, no uno cada una.
func _make_note(clue: Dictionary, is_false: bool, with_pin: bool = true) -> Control:
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

	if with_pin:
		item.add_child(_make_pin(NOTE_ITEM.x * 0.5))
	return item


# ---------------------------------------------------------------------------
#  FOTO DE ESCENA (localización clave visitada) — polaroid apaisada
# ---------------------------------------------------------------------------
func _make_scene_photo(bg_key: String, cap: String) -> Control:
	var item := Control.new()
	item.custom_minimum_size = SCENE_ITEM
	item.size = SCENE_ITEM
	item.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var card := Panel.new()
	card.size = SCENE_ITEM
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var csb := StyleBoxFlat.new()
	csb.bg_color = COL_CREAM
	csb.set_corner_radius_all(2)
	csb.set_border_width_all(1)
	csb.border_color = Color(0.74, 0.71, 0.61)
	csb.shadow_color = Color(0, 0, 0, 0.55)
	csb.shadow_size = 10
	csb.shadow_offset = Vector2(3, 5)
	card.add_theme_stylebox_override("panel", csb)
	item.add_child(card)

	var photo := Panel.new()
	photo.clip_contents = true
	photo.position = Vector2(8, 8)
	photo.size = Vector2(SCENE_ITEM.x - 16, SCENE_ITEM.y - 42)
	photo.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var pbg := StyleBoxFlat.new()
	pbg.bg_color = Color(0.05, 0.05, 0.06)
	photo.add_theme_stylebox_override("panel", pbg)
	card.add_child(photo)

	var tex := TextureRect.new()
	tex.set_anchors_preset(Control.PRESET_FULL_RECT)
	tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	tex.texture = load(Story.BGS[bg_key])
	tex.mouse_filter = Control.MOUSE_FILTER_IGNORE
	photo.add_child(tex)

	var capl := Label.new()
	capl.text = Global.loc(cap)
	capl.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
	capl.clip_text = true
	capl.position = Vector2(6, SCENE_ITEM.y - 31)
	capl.size = Vector2(SCENE_ITEM.x - 12, 26)
	capl.add_theme_font_size_override("font_size", 14)
	capl.add_theme_color_override("font_color", COL_INK)
	capl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(capl)

	item.add_child(_make_pin(SCENE_ITEM.x * 0.5))
	return item


# ---------------------------------------------------------------------------
#  FOTO DE OBJETO ENCONTRADO — polaroid (usa assets/objects/<slug-del-titulo>.png)
# ---------------------------------------------------------------------------
func _make_object_photo(clue: Dictionary, img_path: String, is_false: bool, with_pin: bool = true) -> Control:
	var item := Control.new()
	item.custom_minimum_size = OBJECT_ITEM
	item.size = OBJECT_ITEM
	item.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var card := Panel.new()
	card.size = OBJECT_ITEM
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var csb := StyleBoxFlat.new()
	csb.bg_color = COL_PAPER_OFF if is_false else COL_CREAM
	csb.set_corner_radius_all(2)
	csb.set_border_width_all(1)
	csb.border_color = Color(0.74, 0.71, 0.61)
	csb.shadow_color = Color(0, 0, 0, 0.55)
	csb.shadow_size = 10
	csb.shadow_offset = Vector2(3, 5)
	card.add_theme_stylebox_override("panel", csb)
	item.add_child(card)

	var photo := Panel.new()
	photo.clip_contents = true
	photo.position = Vector2(8, 8)
	photo.size = Vector2(OBJECT_ITEM.x - 16, OBJECT_ITEM.y - 46)
	photo.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var pbg := StyleBoxFlat.new()
	pbg.bg_color = Color(0.06, 0.06, 0.07)
	photo.add_theme_stylebox_override("panel", pbg)
	card.add_child(photo)

	var tex := TextureRect.new()
	tex.set_anchors_preset(Control.PRESET_FULL_RECT)
	tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	tex.texture = load(img_path)
	tex.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if is_false:
		tex.modulate = Color(0.7, 0.7, 0.7, 1.0)
	photo.add_child(tex)

	var capl := Label.new()
	capl.text = Global.loc(String(clue.get("title", "")))
	capl.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
	capl.clip_text = true
	capl.position = Vector2(6, OBJECT_ITEM.y - 34)
	capl.size = Vector2(OBJECT_ITEM.x - 12, 28)
	capl.add_theme_font_size_override("font_size", 14)
	capl.add_theme_color_override("font_color", Color(0.30, 0.30, 0.30) if is_false else COL_INK)
	capl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(capl)

	if is_false:
		var cross := Label.new()
		cross.text = "✗"
		cross.position = Vector2(8, 8)
		cross.size = Vector2(OBJECT_ITEM.x - 16, OBJECT_ITEM.y - 46)
		cross.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
		cross.vertical_alignment = VerticalAlignment.VERTICAL_ALIGNMENT_CENTER
		cross.add_theme_font_size_override("font_size", 100)
		cross.add_theme_color_override("font_color", Color(Global.COL_ACCENT.r, Global.COL_ACCENT.g, Global.COL_ACCENT.b, 0.85))
		cross.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.add_child(cross)

	if with_pin:
		item.add_child(_make_pin(OBJECT_ITEM.x * 0.5))
	return item


## Ruta de la foto del objeto de una pista (assets/objects/<slug-del-titulo>.png)
## o "" si no existe. El slug lo comparte el generador tools/gen_objects.py.
func _object_image_for(clue: Dictionary) -> String:
	return Global.clue_image(String(clue.get("title", "")))


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
	if _closing:
		return
	if event.is_action_pressed("pause") or event.is_action_pressed("notebook"):
		accept_event()
		_close()
