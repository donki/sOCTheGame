extends Node
## Captura del TABLERO JUGABLE para revisarlo a ojo (no es un test).
## Monta el tablero del Cap. 1 con las 6 pistas, une una pareja de verdad y guarda
## dos PNG: el tablero recién abierto y el mismo con un hilo ya tendido.
## Ejecutar:  godot res://tools/ShotBoard.tscn   (con ventana: necesita pintar)

const OUT := "user://shot_board_%s.png"


func _ready() -> void:
	Global.tool_mode = true
	Global.reset_case()
	Global.chapter = 1
	for c in [["La cita sin nombre", "En la agenda de Marta, una cita sin nombre la noche en que desapareció."],
			["El grito", "Durante las campanas se oyó un grito junto al altar."],
			["La puerta principal", "Nadie salió por la puerta principal: alguien vigilaba."],
			["El encapuchado", "Marta discutió ayer con un hombre encapuchado."],
			["El campanario", "La puerta del campanario estaba abierta esa noche."],
			["El pañuelo", "Un pañuelo con las iniciales M.S. junto a la escalera del campanario."]]:
		Global.add_clue(c[0], c[1])
	# Las falsas del bar del Nano, para ver también el montón de descartadas.
	Global.add_clue("El exnovio", "Coartada de hierro: pasó la noche en el calabozo.", true)
	Global.add_clue("El tendero fisgón", "Solo repite chismes de mostrador.", true)

	var b := EvidenceBoard.new()
	add_child(b)
	await get_tree().process_frame
	await get_tree().create_timer(0.6).timeout   # deja acabar el fundido de entrada
	await _shot("abierto")

	# Une una pareja buena, como haría la jugadora, y captura el hilo tendido.
	_drag(b, "La puerta principal", "El campanario")
	await get_tree().create_timer(0.5).timeout
	await _shot("hilo")

	print("Capturas en: ", ProjectSettings.globalize_path("user://"))
	get_tree().quit(0)


func _drag(b: EvidenceBoard, a: String, z: String) -> void:
	var pa: Vector2 = b._content_host.get_transform() * _center(b, a)
	var pz: Vector2 = b._content_host.get_transform() * _center(b, z)
	var down := InputEventMouseButton.new()
	down.button_index = MOUSE_BUTTON_LEFT
	down.pressed = true
	down.position = pa
	b._on_viewport_input(down)
	var mv := InputEventMouseMotion.new()
	mv.position = pz
	b._on_viewport_input(mv)
	var up := InputEventMouseButton.new()
	up.button_index = MOUSE_BUTTON_LEFT
	up.pressed = false
	up.position = pz
	b._on_viewport_input(up)


func _center(b: EvidenceBoard, title: String) -> Vector2:
	var n: Control = b._clue_nodes[title]["node"]
	return n.position + n.size * 0.5


func _shot(tag: String) -> void:
	await RenderingServer.frame_post_draw
	var img := get_viewport().get_texture().get_image()
	img.save_png(OUT % tag)
