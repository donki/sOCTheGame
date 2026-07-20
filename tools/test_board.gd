extends Node
## Test de usuario automatizado del TABLERO JUGABLE (headless).
##
## Juega el tablero del Capítulo 1 como lo haría una jugadora: monta el EvidenceBoard
## real con el estado real del juego y TIENDE HILOS de verdad, mandando los eventos de
## ratón que mandaría la mano (press sobre una pista, mover, soltar sobre otra). No
## llama a la lógica por dentro: entra por _on_viewport_input, igual que el juego.
##
## Cubre: que no se juegue mientras falten pistas, que la pareja mala se rechace, que
## la buena se quede, que unir las tres cierre el caso (bandera + señal), y que el
## progreso sobreviva a cerrar y reabrir el tablero.
##
## Ejecutar:  godot --headless res://tools/TestBoard.tscn

var _pass := true
var _log: Array = []


func _ready() -> void:
	await _run()
	_report()
	get_tree().quit(0 if _pass else 1)


func _check(cond: bool, msg: String) -> void:
	_log.append(("  [OK]   " if cond else "  [FAIL] ") + msg)
	if not cond:
		_pass = false


func _run() -> void:
	Global.tool_mode = true   # el test NO debe pisar la partida real
	Global.reset_case()
	Global.chapter = 1

	print("\n=== Tablero: sin todas las pistas no se juega ===")
	await _test_incompleto()

	print("=== Tablero: tender hilos ===")
	await _test_jugable()

	print("=== Tablero: el progreso sobrevive a reabrirlo ===")
	await _test_persistencia()


# ---------------------------------------------------------------------------
#  Utilidades
# ---------------------------------------------------------------------------
## Todas las pistas que las parejas del capítulo necesitan, sacadas de Story.links()
## para que el test no se quede atrás cuando cambien los datos del capítulo.
func _add_all_clues() -> void:
	for l in Story.links():
		Global.add_clue(String(l["a"]), "…")
		Global.add_clue(String(l["b"]), "…")


func _make_board() -> EvidenceBoard:
	var b := EvidenceBoard.new()
	add_child(b)
	await get_tree().process_frame
	await get_tree().process_frame   # deja que _ready monte el corcho y coloque todo
	return b


## Manda el gesto completo de tender un hilo entre dos pistas, en coordenadas de
## pantalla, como haría la mano: pulsar sobre una, arrastrar, soltar sobre la otra.
func _drag_thread(b: EvidenceBoard, from_title: String, to_title: String) -> void:
	var from_vp: Vector2 = _pin_vp(b, from_title)
	var to_vp: Vector2 = _pin_vp(b, to_title)
	var down := InputEventMouseButton.new()
	down.button_index = MOUSE_BUTTON_LEFT
	down.pressed = true
	down.position = from_vp
	b._on_viewport_input(down)

	var move := InputEventMouseMotion.new()
	move.position = to_vp
	b._on_viewport_input(move)

	var up := InputEventMouseButton.new()
	up.button_index = MOUSE_BUTTON_LEFT
	up.pressed = false
	up.position = to_vp
	b._on_viewport_input(up)


## Centro de la tarjeta de una pista, en coordenadas del viewport del tablero.
## Se apunta al CENTRO (no a la chincheta): es donde pincharía una persona.
func _pin_vp(b: EvidenceBoard, title: String) -> Vector2:
	var node: Control = b._clue_nodes[title]["node"]
	return b._content_host.get_transform() * (node.position + node.size * 0.5)


# ---------------------------------------------------------------------------
#  Casos
# ---------------------------------------------------------------------------
## Con pistas a medias el tablero es escaparate: no se puede cerrar el caso antes
## de haber investigado.
func _test_incompleto() -> void:
	Global.clues.clear()
	Global.flags.clear()
	# Solo una pareja de las cuatro: aún falta media investigación.
	Global.add_clue(String(Story.links()[0]["a"]), "…")
	Global.add_clue(String(Story.links()[0]["b"]), "…")
	var b := await _make_board()
	_check(not b._play, "faltando pistas: el tablero NO es jugable")
	_check(b._thread.points.size() > 0 or b._clue_nodes.size() < 2,
		"faltando pistas: sigue el hilo decorativo de siempre")
	b.free()


func _test_jugable() -> void:
	Global.clues.clear()
	Global.flags.clear()
	_add_all_clues()
	var links: Array = Story.links()
	var n: int = links.size()
	var b := await _make_board()
	_check(b._play, "con todas las pistas: el tablero ES jugable")
	_check(b._clue_nodes.size() == n * 2,
		"las %d pistas de las parejas quedan enganchables (hay %d)" % [n * 2, b._clue_nodes.size()])
	_check(b._thread.points.size() == 0, "jugando: sin hilo decorativo (solo el del jugador)")

	# --- Pareja que no cuadra: se rechaza y no cuenta. Cruzamos dos parejas
	#     distintas, así que es imposible que sea buena por casualidad.
	_drag_thread(b, String(links[0]["a"]), String(links[1]["b"]))
	_check(b._solved.is_empty(), "pareja incorrecta: rechazada (0 resueltas)")
	_check(not Global.has_flag("tablero_cap1"), "pareja incorrecta: el caso sigue abierto")

	# --- Las buenas, una a una ---
	var closed := [false]
	b.case_closed.connect(func() -> void: closed[0] = true)

	for i in n:
		_drag_thread(b, String(links[i]["a"]), String(links[i]["b"]))
		_check(b._solved.size() == i + 1, "pareja buena %d/%d: se queda clavada" % [i + 1, n])
		_check(Global.has_flag(Story.link_flag(i)), "pareja buena %d/%d: se recuerda por bandera" % [i + 1, n])
		if i == 0 and n > 1:
			# Una pista ya atada no se vuelve a tocar.
			_drag_thread(b, String(links[0]["a"]), String(links[1]["a"]))
			_check(b._solved.size() == 1, "pista ya atada: no se re-arrastra")

	_check(Global.has_flag("tablero_cap1"), "las %d parejas CIERRAN el caso (bandera del tablero)" % n)

	# El cierre se canta tras una pausa para leerlo; la señal llega después.
	await get_tree().create_timer(2.2).timeout
	_check(closed[0], "el tablero emite case_closed (CityMap encadena el epílogo)")
	_check(not Global.has_flag(Story.end_flag()),
		"el tablero NO avanza de capítulo por su cuenta (eso es del epílogo)")
	if is_instance_valid(b):
		b.free()


## Cerrar el tablero a medias no obliga a rehacer las parejas ya ganadas.
func _test_persistencia() -> void:
	Global.clues.clear()
	Global.flags.clear()
	_add_all_clues()
	var b := await _make_board()
	_drag_thread(b, String(Story.links()[0]["a"]), String(Story.links()[0]["b"]))
	_check(b._solved.size() == 1, "una pareja unida antes de cerrar")
	b.free()

	var b2 := await _make_board()
	_check(b2._solved.size() == 1, "al reabrir: la pareja sigue unida")
	_check(b2._play, "al reabrir: se puede seguir jugando")
	_check(b2._links_layer.get_child_count() == 1, "al reabrir: su hilo se redibuja")
	b2.free()


func _report() -> void:
	print("\n".join(_log))
	var fails := 0
	for l in _log:
		if String(l).begins_with("  [FAIL]"):
			fails += 1
	print("----------------------------------------------------------------")
	print("Comprobaciones: %d   ·   Fallos: %d   ·   %s"
		% [_log.size(), fails, "TODO OK ✅" if _pass else "HAY FALLOS ❌"])
	print("----------------------------------------------------------------")
