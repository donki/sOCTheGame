extends Node
## Test de usuario automatizado del Capítulo 1 (headless).
##
## Juega el capítulo COMPLETO a través de las escenas reales (DialogueView + Story +
## Global), como haría una jugadora: viaja a cada localización, avanza todos los beats
## (eligiendo siempre la primera opción) y comprueba que las pistas, las puertas por
## requisito y el cierre del capítulo funcionan. Además valida que existan todos los
## retratos/fondos y que los diálogos estén bien formados.
##
## Ejecutar: fijar este .tscn como main_scene y correr headless (ver tools/run_test_cap1).

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
	Global.tool_mode = true   # el playthrough de test NO debe pisar la partida real
	Global.reset_case()
	Global.chapter = 1        # reset_case arranca en el 0 (tutorial); esto prueba el Cap. 1

	print("\n=== Validación de assets ===")
	_validate_assets()

	print("=== Validación de diálogos ===")
	for loc in Story.locations():
		var dlg: Dictionary = Story.get_dialogue(loc.id)
		_check(dlg.has("beats") and not (dlg.beats as Array).is_empty(),
			"%s: diálogo con beats" % loc.id)
		_validate_beats(dlg.get("beats", []), loc.id)

	print("=== Playthrough del Capítulo 1 ===")
	_check(Story.location_state("iglesia") == "locked", "Iglesia BLOQUEADA sin las 4 pistas")
	_check(Story.location_state("comisaria") == "locked", "Comisaría BLOQUEADA al inicio")

	await _visit("plaza")
	_check(Global.has_flag("done_plaza"), "Plaza: marcada como visitada")

	_check(Story.location_state("casa_marta") == "available", "Casa de Marta: disponible tras la plaza")
	var m_before: int = Global.clues.size()
	await _visit("casa_marta")
	# Dos: la de la escena de búsqueda (la taza) y la del diálogo (la cita).
	_check(Global.clues.size() == m_before + 2, "Casa de Marta: aporta 2 pistas (escena + diálogo)")
	_check(Global.has_flag("done_casa_marta"), "Casa de Marta: marcada como visitada")

	for id in ["emilio", "rosa", "tomas", "carmen"]:
		_check(Story.location_state(id) == "available", "%s: disponible" % id)
		var before: int = Global.clues.size()
		await _visit(id)
		_check(Global.clues.size() == before + 1, "%s: aporta 1 pista nueva" % id)
		_check(Global.has_flag("done_" + id), "%s: marcado como hablado" % id)

	_check(Story.street_clues_count() == 4, "Reunidas las 4 pistas de calle")
	_check(Story.location_state("iglesia") == "available", "Iglesia DESBLOQUEADA con 4 pistas")

	await _visit("iglesia")
	_check(Global.has_flag("cap1_completo"), "Capítulo 1 COMPLETADO tras la iglesia")
	# 8 = las 6 de diálogo (cita + 4 de calle + pañuelo) y las 2 de escena
	# (el reflejo en el charco, la taza a medias). Las 8 se atan en el tablero.
	_check(Global.clues.size() == 8, "8 pistas tras la iglesia (6 de diálogo + 2 de escena)")

	# El caso ya no lo cierra la comisaría: lo cierra el TABLERO. Hasta atar las
	# pistas, el cierre sigue bajo llave (no se puede saltar el tablero).
	_check(Story.location_state("comisaria") == "locked", "Comisaría BLOQUEADA hasta atar las pistas")
	await _play_board()
	_check(Global.has_flag("tablero_cap1"), "Tablero: las 3 parejas cierran el caso")
	_check(Story.location_state("comisaria") == "available", "Comisaría DESBLOQUEADA tras el tablero")

	await _visit("comisaria")
	_check(Global.has_flag("done_comisaria"), "Comisaría visitada (gancho al cap. 2)")

	# Revisita: no debe duplicar pistas.
	var n: int = Global.clues.size()
	await _visit("emilio")
	_check(Global.clues.size() == n, "Revisita a Emilio no duplica pistas")

	# Validación estructural de los capítulos 2 y 3 (contenido bien formado).
	_validate_all_chapters()

	# Cada red herring de CADA capítulo (1-20) debe repartir 5 pistas FALSAS.
	_validate_red_herrings()

	# Las parejas del tablero de LOS 20 capítulos: que sean jugables de verdad.
	_validate_links()


# ---------------------------------------------------------------------------
#  VALIDACIONES ESTÁTICAS
# ---------------------------------------------------------------------------
func _note(cond: bool, msg: String) -> void:
	# Comprobación blanda: informa pero NO hace fallar el test (arte con fallback).
	_log.append(("  [OK]   " if cond else "  [--]   ") + msg)


func _validate_assets() -> void:
	# Existencia de arte: blanda (si falta, el juego degrada con silueta/rótulo).
	for k in Story.CHARS:
		var p: String = Story.CHARS[k].portrait
		if p != "":
			_note(ResourceLoader.exists(p), "Retrato: %s" % p.get_file())
	for k in Story.BGS:
		_note(ResourceLoader.exists(Story.BGS[k]), "Fondo: %s" % String(Story.BGS[k]).get_file())
	_check(ResourceLoader.exists("res://assets/backgrounds/mapa.png"), "Mapa existe")
	_check(ResourceLoader.exists("res://assets/backgrounds/splash.png"), "Splash existe")


func _validate_red_herrings() -> void:
	print("=== Pistas falsas por capítulo (deben ser 5 en cada red herring) ===")
	for ch in range(1, 21):
		Global.chapter = ch
		for loc in Story.locations():
			if not loc.get("red_herring", false):
				continue
			var dlg: Dictionary = Story.get_dialogue(loc.id)
			var n := 0
			if dlg.has("clue") and (dlg.clue as Dictionary).get("false", false):
				n += 1
			if dlg.has("clues"):
				for c in dlg.clues:
					if (c as Dictionary).get("false", false):
						n += 1
			_check(n == 5, "Cap %d · %s: 5 pistas falsas (tiene %d)" % [ch, loc.id, n])
	Global.chapter = 1


## Las parejas del tablero (Story.CHX_LINKS) son texto escrito a mano: un título con
## una tilde de más y esa pareja sería IMPOSIBLE de unir, dejando el capítulo sin
## cerrar. Esto lo caza aquí y no en la partida de alguien.
## Comprueba, capítulo a capítulo: que los títulos existan como pista REAL de ESE
## capítulo, que no se repita una pista en dos parejas (el tablero no la reutiliza),
## que no se ate una pista consigo misma, y que el cierre esté regateado por el
## tablero (si no, se podría saltar la mecánica yendo a la comisaría).
func _validate_links() -> void:
	print("=== Validación de las parejas del tablero ===")
	# Con banderas puestas, get_dialogue() devuelve la variante de REVISITA (que no
	# da pista): hay que mirar los capítulos como los ve una partida nueva.
	Global.flags.clear()
	for ch in range(0, 21):
		Global.chapter = ch
		var links: Array = Story.links()
		if links.is_empty():
			continue
		var reales := _real_clue_titles(ch)
		var usadas: Dictionary = {}
		for l in links:
			var a := String(l.get("a", ""))
			var b := String(l.get("b", ""))
			_check(a in reales, "Cap %d · '%s' es pista real del capítulo" % [ch, a])
			_check(b in reales, "Cap %d · '%s' es pista real del capítulo" % [ch, b])
			_check(a != b, "Cap %d · pareja de dos pistas distintas" % ch)
			_check(not usadas.has(a) and not usadas.has(b),
				"Cap %d · '%s'+'%s' no reutilizan pista de otra pareja" % [ch, a, b])
			usadas[a] = true
			usadas[b] = true
			_check(String(l.get("text", "")) != "", "Cap %d · la pareja canta su deducción" % ch)
		# El cierre del capítulo debe exigir el tablero, o la mecánica sería opcional.
		var epi := Story.epilogue_id()
		_check(epi != "", "Cap %d · tiene epílogo declarado" % ch)
		var found := false
		for loc in Story.locations():
			if String(loc.id) == epi:
				found = true
				_check(String(loc.get("req", "")) == Story.links_flag(),
					"Cap %d · el cierre '%s' exige el tablero" % [ch, epi])
		_check(found, "Cap %d · el epílogo '%s' existe en el mapa" % [ch, epi])


## Títulos de las pistas VERDADERAS que el capítulo llega a soltar, diálogos y
## mini-escenas incluidas (las de escena están garantizadas: no se sale de una
## búsqueda sin encontrar la pista).
func _real_clue_titles(ch: int) -> Array:
	Global.chapter = ch
	var out: Array = []
	for loc in Story.locations():
		for d in [Story.get_dialogue(String(loc.id)), Story.interact_data(String(loc.id))]:
			var cs: Array = []
			if typeof(d.get("clue")) == TYPE_DICTIONARY:
				cs.append(d["clue"])
			for c in d.get("clues", []):
				cs.append(c)
			for c in cs:
				if typeof(c) == TYPE_DICTIONARY and not bool(c.get("false", false)):
					var t := String(c.get("title", ""))
					if t != "" and not (t in out):
						out.append(t)
	return out


func _validate_all_chapters() -> void:
	for ch in range(2, 21):
		Global.chapter = ch
		print("=== Validación de diálogos · Capítulo %d ===" % ch)
		for loc in Story.locations():
			var dlg: Dictionary = Story.get_dialogue(loc.id)
			_check(dlg.has("beats") and not (dlg.beats as Array).is_empty(),
				"c%d/%s: diálogo con beats" % [ch, loc.id])
			_validate_beats(dlg.get("beats", []), "c%d/%s" % [ch, loc.id])
	Global.chapter = 1


func _validate_beats(beats: Array, id: String) -> void:
	for b in beats:
		if b.has("choices"):
			for ch in b.choices:
				_check(ch.has("text") and ch.has("then"), "%s: elección bien formada" % id)
				_validate_beats(ch.get("then", []), id)
		else:
			var who: String = b.get("who", "narrador")
			_check(Story.CHARS.has(who), "%s: locutor '%s' válido" % [id, who])
			if b.has("bg"):
				_check(Story.BGS.has(b.bg), "%s: bg '%s' válido" % [id, b.bg])


# ---------------------------------------------------------------------------
#  PLAYTHROUGH REAL (conduce el DialogueView como una jugadora)
# ---------------------------------------------------------------------------
## Juega el TABLERO como la jugadora: monta el EvidenceBoard real y tiende los hilos
## mandando eventos de ratón (press sobre una pista, mover, soltar sobre la otra).
## Las parejas salen de Story.links(), así que el test no las repite a mano: si
## cambian los datos del capítulo, esto sigue valiendo.
func _play_board() -> void:
	var b := EvidenceBoard.new()
	add_child(b)
	await get_tree().process_frame
	await get_tree().process_frame
	if not b._play:
		_check(false, "Tablero: jugable con las 6 pistas")
		b.free()
		return
	for l in Story.links():
		_drag_thread(b, String(l["a"]), String(l["b"]))
	await get_tree().create_timer(2.0).timeout   # el cierre se canta antes de emitir
	if is_instance_valid(b):
		b.free()


func _drag_thread(b: EvidenceBoard, from_title: String, to_title: String) -> void:
	var from_vp: Vector2 = _card_vp(b, from_title)
	var to_vp: Vector2 = _card_vp(b, to_title)
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


## Centro de la tarjeta de una pista, en coordenadas del viewport del tablero:
## donde pincharía una persona.
func _card_vp(b: EvidenceBoard, title: String) -> Vector2:
	var node: Control = b._clue_nodes[title]["node"]
	return b._content_host.get_transform() * (node.position + node.size * 0.5)


## Visita una localización como el juego: si es la PRIMERA vez y tiene mini-escena
## (búsqueda/examinar/…), esa escena se resuelve antes y suelta su pista, igual que
## hace CityMap._open_dialogue(); después va el diálogo. Sin esto el playthrough se
## saltaba las pistas de escena y el capítulo se quedaba corto de pistas.
func _visit(id: String) -> void:
	var idata: Dictionary = Story.interact_data(id)
	if not idata.is_empty() and not Global.has_flag("done_" + id) \
			and not Global.has_flag(String(idata.get("flag", ""))):
		_resolve_interaction(idata)
	var dlg: Dictionary = Story.get_dialogue(id)
	if dlg.is_empty():
		_check(false, "%s: get_dialogue devolvió vacío" % id)
		return
	await _play(dlg)


## Desenlace de una mini-escena, igual que hace su vista al terminar (p. ej.
## SearchView._finish()): concede la pista y marca la bandera. No se puede salir de
## una búsqueda sin encontrar la pista, así que esto es lo que SIEMPRE ocurre.
func _resolve_interaction(idata: Dictionary) -> void:
	if typeof(idata.get("clue")) == TYPE_DICTIONARY:
		var cl: Dictionary = idata["clue"]
		Global.add_clue(String(cl.title), String(cl.text), cl.get("false", false))
	for c in idata.get("clues", []):
		if typeof(c) == TYPE_DICTIONARY:
			Global.add_clue(String(c.title), String(c.text), c.get("false", false))
	if idata.has("flag"):
		Global.set_flag(String(idata.flag), true)


func _play(dlg: Dictionary) -> void:
	var dv := DialogueView.new()
	add_child(dv)
	var done := {"emitted": false}
	dv.finished.connect(func(_res: Dictionary) -> void: done.emitted = true)
	dv.start(dlg)
	var guard := 0
	var finishing := false
	while not done.emitted and guard < 4000:
		await get_tree().process_frame
		guard += 1
		if not is_instance_valid(dv):
			break
		if finishing:
			continue                      # _finish() ya disparado: solo esperar la señal
		if dv._choosing:
			if dv._choices.get_child_count() > 0:
				(dv._choices.get_child(0) as Button).pressed.emit()
		elif dv._typing:
			dv._finish_typing()           # revela el texto de golpe
		elif dv._queue.is_empty():
			finishing = true
			dv._advance()                 # cola vacía -> dispara _finish() (una sola vez)
		else:
			dv._advance()                 # siguiente beat
	_check(done.emitted, "Diálogo reproducido hasta el final (guard=%d)" % guard)


# ---------------------------------------------------------------------------
func _report() -> void:
	print("\n---------------- RESULTADO DEL TEST · CAPÍTULO 1 ----------------")
	for line in _log:
		print(line)
	var fails := 0
	for line in _log:
		if String(line).begins_with("  [FAIL]"):
			fails += 1
	print("----------------------------------------------------------------")
	print("Comprobaciones: %d   ·   Fallos: %d   ·   %s" % [
		_log.size(), fails, "TODO OK ✅" if _pass else "HAY FALLOS ❌"])
	print("----------------------------------------------------------------\n")
