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
	Global.reset_case()

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
	_check(Global.clues.size() == m_before + 1, "Casa de Marta: aporta 1 pista")
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
	_check(Global.clues.size() == 6, "6 pistas tras la iglesia (cita + 4 de calle + pañuelo)")
	_check(Story.location_state("comisaria") == "available", "Comisaría DESBLOQUEADA")

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
func _visit(id: String) -> void:
	var dlg: Dictionary = Story.get_dialogue(id)
	if dlg.is_empty():
		_check(false, "%s: get_dialogue devolvió vacío" % id)
		return
	await _play(dlg)


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
