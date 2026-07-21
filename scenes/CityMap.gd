extends Control
## Mapa del Barrio Viejo (nucleo del juego de dialogo).
##
## La ciudad es un MAPA: el jugador marca a donde quiere ir tocando un pin de
## localizacion; la detective "viaja" hasta alli y se abre la escena de dialogo
## correspondiente (novela visual). Al volver se actualiza el progreso del caso.

const MAP_IMG := "res://assets/backgrounds/mapa.png"

var _map_bg: Control          # dibujo procedural o imagen del mapa
var _pins: Dictionary = {}    # id -> {btn, label, point:Vector2}
var _token: Panel             # ficha de la detective sobre el mapa
var _nb_btn: Button           # botón de la libreta (destino de la animación de pistas)
var _skip_btn: Button         # botón "Saltar tutorial" (solo visible en el Cap. 0)
var _coach: Control           # coach-mark del tutorial (flecha + cartel señalando el pin)
var _coach_sign: Panel
var _coach_label: Label
var _coach_arrow: Node2D
var _title: Label             # título del capítulo (barra superior)
var _objective: Label
var _toast: Label
var _notebook: Panel
var _notebook_label: Label
var _board_area: Control      # (obsoleto) zona del panel de pistas antiguo
var _board: Control           # instancia del TABLERO (EvidenceBoard) abierto, si lo hay
var _busy := false
var _advancing := false         # avance de capítulo en curso: evita reentrada (doble toque)
var _skipped := false           # el tutorial ya se saltó una vez: no repetir
var _current := Vector2(-1, -1)
var _shown: Dictionary = {}     # localizaciones ya reveladas (para avisar de nuevas)
var _first_refresh := true

# Música ambiente: la genera el autoload `Music` (motor generativo con moods), que
# persiste entre escenas para no cortar la música. El mapa elige un ambiente según
# el capítulo y los diálogos cambian a uno más íntimo/tenso (ver _map_mood/_dialogue_mood).


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_build_map_bg()
	_build_hud()
	_build_pins()
	_build_token()
	_build_coach()
	Music.play_mood(_map_mood())
	get_viewport().size_changed.connect(_relayout)
	call_deferred("_relayout")
	call_deferred("_refresh")


# ---------------------------------------------------------------------------
#  MÚSICA: ambiente del mapa y de los diálogos según el capítulo (tono creciente).
# ---------------------------------------------------------------------------
func _map_mood() -> String:
	var ch: int = Global.chapter
	if ch <= 6:
		return "noir"
	elif ch <= 13:
		return "investigacion"
	return "misterio"


func _dialogue_mood() -> String:
	var ch: int = Global.chapter
	if ch <= 6:
		return "misterio"
	elif ch <= 13:
		return "tension"
	return "revelacion"


# ---------------------------------------------------------------------------
#  FONDO DEL MAPA
# ---------------------------------------------------------------------------
func _build_map_bg() -> void:
	var map_path := Story.chapter_map()   # mapa propio de la región del capítulo
	if ResourceLoader.exists(map_path):
		var tr := TextureRect.new()
		tr.texture = load(map_path)
		tr.set_anchors_preset(Control.PRESET_FULL_RECT)
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(tr)
		_map_bg = tr
	else:
		var m := MapCanvas.new()
		m.set_anchors_preset(Control.PRESET_FULL_RECT)
		m.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(m)
		_map_bg = m


# ---------------------------------------------------------------------------
#  HUD (objetivo, botones, aviso de pista)
# ---------------------------------------------------------------------------
func _build_hud() -> void:
	var bar := Panel.new()
	bar.set_anchors_preset(Control.PRESET_TOP_WIDE)
	bar.offset_bottom = 66
	var bs := StyleBoxFlat.new()
	bs.bg_color = Color(0.04, 0.05, 0.08, 0.86)
	bs.border_width_bottom = 2
	bs.border_color = Global.COL_ACCENT_DIM
	bar.add_theme_stylebox_override("panel", bs)
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bar)

	_title = Label.new()
	_title.text = Global.loc(Story.chapter_title())
	_title.position = Vector2(22, 10)
	Global.style_subtitle(_title, 18)
	_title.add_theme_font_override("font", load(Global.FONT_BODY_PATH))   # fuente de los diálogos
	add_child(_title)

	_objective = Label.new()
	_objective.position = Vector2(22, 36)
	_objective.add_theme_font_size_override("font_size", 15)
	_objective.add_theme_color_override("font_color", Global.COL_WARM)
	add_child(_objective)

	var nb := _mini_button("Tablero (N)", func() -> void: _toggle_notebook(), "res://assets/ui/ic_libreta.png")
	nb.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	nb.offset_left = -116
	nb.offset_right = -72
	nb.offset_top = 14
	nb.offset_bottom = 52
	add_child(nb)
	_nb_btn = nb

	var menu := _mini_button("Menú (Esc)", func() -> void: Global.change_scene("res://scenes/MainMenu.tscn"), "res://assets/ui/ic_menu.png")
	menu.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	menu.offset_left = -58
	menu.offset_right = -14
	menu.offset_top = 14
	menu.offset_bottom = 52
	add_child(menu)

	# Botón "Saltar tutorial": solo durante el Cap. 0. Icono acorde (sin texto). Salta al Cap. 1.
	_skip_btn = _mini_button("Saltar tutorial", func() -> void: _confirm_skip_tutorial(), "res://assets/ui/ic_saltar.png")
	_skip_btn.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_skip_btn.offset_left = -170
	_skip_btn.offset_right = -126
	_skip_btn.offset_top = 14
	_skip_btn.offset_bottom = 52
	_skip_btn.visible = Global.chapter == 0
	add_child(_skip_btn)

	_toast = Label.new()
	_toast.set_anchors_preset(Control.PRESET_CENTER_TOP)
	_toast.anchor_left = 0.5
	_toast.anchor_right = 0.5
	_toast.offset_top = 78
	_toast.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_toast.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_toast.add_theme_font_size_override("font_size", 18)
	_toast.add_theme_color_override("font_color", Global.COL_TEXT)
	_toast.modulate.a = 0.0
	_toast.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_toast)


func _mini_button(text: String, cb: Callable, icon_path := "") -> Button:
	var b := Button.new()
	b.tooltip_text = Global.loc(text)
	if icon_path != "" and ResourceLoader.exists(icon_path):
		b.icon = load(icon_path)
		b.expand_icon = true
		b.custom_minimum_size = Vector2(44, 38)
	else:
		b.text = Global.loc(text)
		b.custom_minimum_size = Vector2(114, 36)
		b.add_theme_font_size_override("font_size", 14)
	b.add_theme_color_override("font_color", Global.COL_TEXT)
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.08, 0.09, 0.12, 0.92)
	sb.set_corner_radius_all(6)
	sb.border_width_left = 2
	sb.border_color = Global.COL_ACCENT_DIM
	sb.set_content_margin_all(8)
	b.add_theme_stylebox_override("normal", sb)
	b.pressed.connect(func() -> void: Global.play_sfx(Global.SFX_CLICK, -5.0))
	b.pressed.connect(cb)
	return b


# ---------------------------------------------------------------------------
#  PINES DE LOCALIZACION
# ---------------------------------------------------------------------------
func _build_pins() -> void:
	for loc in Story.locations():
		var btn := Button.new()
		btn.custom_minimum_size = Vector2(30, 30)
		btn.size = Vector2(30, 30)
		btn.focus_mode = Control.FOCUS_NONE
		btn.tooltip_text = loc.name
		btn.pressed.connect(_on_pin.bind(String(loc.id)))
		add_child(btn)

		var lbl := Label.new()
		lbl.text = Global.loc(loc.name)
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lbl.add_theme_font_size_override("font_size", 13)
		lbl.add_theme_color_override("font_color", Global.COL_TEXT)
		lbl.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
		lbl.add_theme_constant_override("outline_size", 4)
		lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(lbl)

		_pins[loc.id] = {"btn": btn, "label": lbl, "point": Vector2.ZERO}


func _pin_style(state: String, hover: bool) -> StyleBoxFlat:
	# Pines con estética cyberpunk: núcleo oscuro, aro de neón y halo (shadow) que
	# brilla. Rojo/magenta = por visitar; cian/teal = visitada.
	var sb := StyleBoxFlat.new()
	sb.set_corner_radius_all(15)
	sb.set_border_width_all(3)
	sb.anti_aliasing = true
	match state:
		"available":
			sb.bg_color = Color(0.10, 0.02, 0.05, 0.92)
			sb.border_color = Color(1.0, 0.30, 0.38) if not hover else Color(1.0, 0.55, 0.62)
			sb.shadow_color = Color(1.0, 0.18, 0.35, 0.85 if hover else 0.55)
			sb.shadow_size = 20 if hover else 13
		"done":
			sb.bg_color = Color(0.02, 0.10, 0.11, 0.92)
			sb.border_color = Color(0.40, 1.0, 0.95)
			sb.shadow_color = Color(0.30, 1.0, 0.92, 0.60)
			sb.shadow_size = 14
		_:  # locked (normalmente oculto)
			sb.bg_color = Color(0.12, 0.13, 0.16, 0.85)
			sb.border_color = Color(0.40, 0.42, 0.50)
	return sb


func _refresh() -> void:
	if is_instance_valid(_skip_btn):
		_skip_btn.visible = Global.chapter == 0
	var newly: Array = []
	for loc in Story.locations():
		var id: String = loc.id
		if not _pins.has(id):
			continue
		var state := Story.location_state(id)
		var p: Dictionary = _pins[id]
		var btn: Button = p.btn
		# Las localizaciones se revelan a medida que se desbloquean (conversaciones/
		# pistas): las bloqueadas permanecen ocultas en el mapa.
		var visible_pin: bool = state != "locked"
		btn.visible = visible_pin
		p.label.visible = visible_pin
		if visible_pin and not _shown.has(id):
			_shown[id] = true
			if not _first_refresh:
				newly.append(loc.name)
		btn.text = "✓" if state == "done" else ""
		btn.add_theme_font_size_override("font_size", 14)
		btn.add_theme_color_override("font_color", Color(1, 1, 1))
		btn.add_theme_stylebox_override("normal", _pin_style(state, false))
		btn.add_theme_stylebox_override("hover", _pin_style(state, true))
		btn.add_theme_stylebox_override("pressed", _pin_style(state, true))
		btn.add_theme_stylebox_override("focus", _pin_style(state, false))
		# Tutorial: parpadeo en los pines disponibles para señalar dónde tocar.
		if Global.chapter == 0:
			_set_pin_pulse(p, state == "available")
		p.label.add_theme_color_override("font_color",
			Global.COL_TEXT if state != "locked" else Global.COL_TEXT_MUTED)
	_update_objective()
	_update_coach()
	if not newly.is_empty():
		var msg := (Global.loc("Nueva localización: %s") % Global.loc(newly[0])) if newly.size() == 1 \
			else Global.loc("Nuevas localizaciones en el mapa")
		# Color distinto (cian neón) para diferenciarlo de los avisos de pista (cálidos).
		_show_toast(msg, Color(0.40, 0.90, 0.98))
	_first_refresh = false


func _update_objective() -> void:
	# En el tutorial (Cap. 0), instrucciones explícitas paso a paso.
	if Global.chapter == 0:
		_objective.text = _tutorial_objective()
		return
	# Objetivo genérico dirigido por el estado del capítulo actual.
	var n := Story.street_clues_count()
	var total := Story.street_clues().size()
	var txt := ""
	if n < total:
		txt = Global.loc("▸ Sigue el hilo del caso.")
	elif not Global.has_flag(Story.complete_flag()):
		txt = Global.loc("▸ Ya tienes las pistas. Ve al lugar clave del caso.")
	elif not Story.links().is_empty() and not Global.has_flag(Story.links_flag()):
		txt = Global.loc("▸ Reconstruye el caso en el tablero: une pista, persona y zona.")
	elif not Global.has_flag(Story.end_flag()):
		txt = Global.loc("▸ Cierra el caso: informa en la comisaría.")
	elif Story.is_last_chapter():
		txt = Global.loc("▸ Temporada completada. Gracias por jugar.")
	else:
		txt = Global.loc("▸ Caso completado. Empieza el siguiente...")
	_objective.text = txt


func _tutorial_objective() -> String:
	## Instrucción explícita del tutorial según el progreso (guía de dónde tocar).
	if not Global.has_flag("done_brief0"):
		return Global.loc("▸ TUTORIAL: toca la COMISARÍA (el punto que parpadea) para empezar.")
	if not Global.has_flag("done_l0a"):
		return Global.loc("▸ TUTORIAL · BÚSQUEDA: toca la PLAZA y busca la pista en el escenario.")
	if not Global.has_flag("done_rh0"):
		return Global.loc("▸ TUTORIAL · EXAMINAR: toca el CALLEJÓN y examina el detalle con zoom.")
	if not Global.has_flag("done_l0b"):
		return Global.loc("▸ TUTORIAL · PUZZLE: toca la TIENDA y abre el cajón con el código.")
	if not Global.has_flag("done_l0c"):
		return Global.loc("▸ TUTORIAL · PRESENTAR PRUEBA: toca el INTERROGATORIO y pilla la mentira.")
	if not Global.has_flag("cap0_completo"):
		return Global.loc("▸ TUTORIAL · DEDUCCIÓN: toca el ARCHIVO y deduce la conclusión.")
	if not Global.has_flag("done_cierre0"):
		return Global.loc("▸ TUTORIAL: caso resuelto. Toca la COMISARÍA para informar y terminar.")
	return Global.loc("▸ TUTORIAL completado. Empieza el Caso 1...")


func _set_pin_pulse(p: Dictionary, on: bool) -> void:
	## Hace parpadear (alfa) un pin disponible para guiar al jugador en el tutorial.
	var running: bool = p.has("pulse") and is_instance_valid(p["pulse"]) and p["pulse"].is_running()
	if on and not running:
		var btn: Button = p.btn
		var tw := create_tween().set_loops()
		tw.tween_property(btn, "modulate:a", 0.35, 0.55).set_trans(Tween.TRANS_SINE)
		tw.tween_property(btn, "modulate:a", 1.0, 0.55).set_trans(Tween.TRANS_SINE)
		p["pulse"] = tw
	elif not on and p.has("pulse"):
		if is_instance_valid(p["pulse"]):
			p["pulse"].kill()
		p.erase("pulse")
		if is_instance_valid(p.btn):
			p.btn.modulate.a = 1.0


# ---------------------------------------------------------------------------
#  COACH MARK DEL TUTORIAL (flecha + cartel señalando el pin a tocar)
# ---------------------------------------------------------------------------
func _build_coach() -> void:
	_coach = Control.new()
	_coach.set_anchors_preset(Control.PRESET_FULL_RECT)
	_coach.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_coach.z_index = 50
	_coach.visible = false
	add_child(_coach)

	_coach_sign = Panel.new()
	_coach_sign.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.09, 0.07, 0.05, 0.97)
	sb.set_corner_radius_all(9)
	sb.set_border_width_all(2)
	sb.border_color = Global.COL_WARM
	sb.shadow_color = Color(0, 0, 0, 0.6)
	sb.shadow_size = 10
	sb.set_content_margin_all(9)
	_coach_sign.add_theme_stylebox_override("panel", sb)
	_coach.add_child(_coach_sign)

	_coach_label = Label.new()
	_coach_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	_coach_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_coach_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_coach_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_coach_label.add_theme_font_size_override("font_size", 16)
	_coach_label.add_theme_color_override("font_color", Global.COL_WARM)
	_coach_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
	_coach_label.add_theme_constant_override("outline_size", 4)
	_coach_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_coach_sign.add_child(_coach_label)

	# Flecha: triángulo ámbar (con borde oscuro) que apunta a +x y rebota hacia el pin.
	_coach_arrow = Node2D.new()
	_coach.add_child(_coach_arrow)
	var inner := Node2D.new()
	_coach_arrow.add_child(inner)
	var trib := Polygon2D.new()
	trib.polygon = PackedVector2Array([Vector2(-27, -18), Vector2(11, 0), Vector2(-27, 18)])
	trib.color = Color(0, 0, 0, 0.75)
	inner.add_child(trib)
	var tri := Polygon2D.new()
	tri.polygon = PackedVector2Array([Vector2(-22, -14), Vector2(6, 0), Vector2(-22, 14)])
	tri.color = Global.COL_WARM
	inner.add_child(tri)
	var tw := create_tween().set_loops()
	tw.tween_property(inner, "position:x", 10.0, 0.45).set_trans(Tween.TRANS_SINE)
	tw.tween_property(inner, "position:x", 0.0, 0.45).set_trans(Tween.TRANS_SINE)


func _tutorial_target_pin() -> String:
	if Global.chapter != 0:
		return ""
	if not Global.has_flag("done_brief0"): return "brief0"
	if not Global.has_flag("done_l0a"):    return "l0a"
	if not Global.has_flag("done_rh0"):    return "rh0"
	if not Global.has_flag("done_l0b"):    return "l0b"
	if not Global.has_flag("done_l0c"):    return "l0c"
	if not Global.has_flag("cap0_completo"): return "fin0"
	if not Global.has_flag("done_cierre0"):  return "cierre0"
	return ""


func _update_coach() -> void:
	if _coach == null:
		return
	if _busy:                     # hay una escena abierta: nunca mostrar el coach encima
		_coach.visible = false
		return
	var id := _tutorial_target_pin()
	if id == "" or not _pins.has(id) or not _pins[id].btn.visible:
		_coach.visible = false
		return
	var pin: Vector2 = _pins[id].point
	var vp := get_viewport_rect().size
	var sign_w := 236.0
	var sign_h := 66.0
	var left_side := pin.x > vp.x * 0.5      # pin a la derecha -> cartel a la izquierda, flecha ->
	if left_side:
		_coach_arrow.scale.x = 1.0
		_coach_arrow.position = Vector2(pin.x - 30.0, pin.y)
		_coach_sign.position = Vector2(pin.x - 62.0 - sign_w, pin.y - sign_h * 0.5)
	else:
		_coach_arrow.scale.x = -1.0
		_coach_arrow.position = Vector2(pin.x + 30.0, pin.y)
		_coach_sign.position = Vector2(pin.x + 62.0, pin.y - sign_h * 0.5)
	var sp := _coach_sign.position
	sp.x = clampf(sp.x, 12.0, vp.x - sign_w - 12.0)
	sp.y = clampf(sp.y, 70.0, vp.y - sign_h - 12.0)
	_coach_sign.position = sp
	_coach_sign.size = Vector2(sign_w, sign_h)
	var nm := Global.loc(_loc_name(id))
	_coach_label.text = (Global.loc("¡Empieza aquí! ▸ %s") % nm) if id == "brief0" else (Global.loc("Toca aquí ▸ %s") % nm)
	_coach.visible = true


# ---------------------------------------------------------------------------
#  FICHA / VIAJE
# ---------------------------------------------------------------------------
func _build_token() -> void:
	_token = Panel.new()
	_token.custom_minimum_size = Vector2(18, 18)
	_token.size = Vector2(18, 18)
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.45, 0.82, 0.85, 1.0)
	sb.set_corner_radius_all(9)
	sb.border_width_left = 3
	sb.border_width_top = 3
	sb.border_width_right = 3
	sb.border_width_bottom = 3
	sb.border_color = Color(0.9, 0.98, 1.0)
	_token.add_theme_stylebox_override("panel", sb)
	_token.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_token.pivot_offset = _token.size * 0.5   # escalar desde el centro (animación de viaje)
	add_child(_token)


func _on_pin(id: String) -> void:
	if _busy:
		return
	var state := Story.location_state(id)
	if state == "locked":
		Global.play_sfx(Global.SFX_BACK, -4.0)
		_show_toast(Global.loc(Story.locked_reason(id)), Global.COL_TEXT_MUTED)
		return
	Global.play_sfx(Global.SFX_CONFIRM, -4.0)
	_travel_to(id)


func _travel_to(id: String) -> void:
	_busy = true
	_set_pins_enabled(false)
	if is_instance_valid(_coach):
		_coach.visible = false   # el coach-mark desaparece al viajar/abrir la escena
	var dest: Vector2 = _pins[id].point
	var origin := _current
	var first := origin.x < 0
	var dur := 0.55
	if not first:
		dur = clampf(origin.distance_to(dest) / 900.0, 0.45, 1.3)
	else:
		_token.position = dest - _token.size * 0.5
	_show_toast(Global.loc("Viajando a %s...") % Global.loc(_loc_name(id)), Global.COL_WARM)
	# Aro pulsante en el destino para marcar adónde va (sin línea de estela).
	if not first:
		_ping_at(dest)
	var t := create_tween()
	t.set_parallel(true)
	t.tween_property(_token, "position", dest - _token.size * 0.5, dur).set_trans(Tween.TRANS_SINE)
	t.tween_property(_token, "scale", Vector2(1.6, 1.6), dur * 0.5).set_trans(Tween.TRANS_SINE)
	t.chain().tween_property(_token, "scale", Vector2(1, 1), dur * 0.5)
	await t.finished
	_current = dest
	_open_dialogue(id)


func _ping_at(pos: Vector2) -> void:
	## Aro que se expande y desvanece en el destino del viaje.
	var ring := Panel.new()
	var d := 14.0
	ring.custom_minimum_size = Vector2(d, d)
	ring.size = Vector2(d, d)
	ring.position = pos - Vector2(d, d) * 0.5
	ring.pivot_offset = Vector2(d, d) * 0.5
	ring.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ring.z_index = 4
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0, 0, 0, 0)
	sb.set_corner_radius_all(int(d))
	sb.border_width_left = 2
	sb.border_width_top = 2
	sb.border_width_right = 2
	sb.border_width_bottom = 2
	sb.border_color = Color(0.45, 0.90, 0.98, 0.9)
	ring.add_theme_stylebox_override("panel", sb)
	add_child(ring)
	var t := create_tween()
	t.set_parallel(true)
	t.tween_property(ring, "scale", Vector2(3.2, 3.2), 0.7).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	t.tween_property(ring, "modulate:a", 0.0, 0.7)
	t.chain().tween_callback(ring.queue_free)


func _open_dialogue(id: String) -> void:
	Music.play_mood(_dialogue_mood())   # ambiente más íntimo/tenso durante la escena
	# La PRIMERA visita a una localización con interacción abre su mini-escena jugable
	# (búsqueda, examinar, puzzle, presentar prueba, deducir). En los casos reales, las
	# escenas de BÚSQUEDA encadenan luego el diálogo (then_dialogue) para no perder la
	# narrativa: buscas la pista en el escenario y después hablas con quien toque.
	var idata := Story.interact_data(id)
	if not idata.is_empty() and not Global.has_flag("done_" + id) \
			and not Global.has_flag(String(idata.get("flag", ""))):
		var view := _make_interaction(idata)
		if view != null:
			view.z_index = 100   # por encima del HUD del mapa (barra, pines, coach)
			add_child(view)
			view.connect("finished", _on_interaction_finished.bind(id))
			view.call("start", idata)
			return
	_open_dialogue_view(id)


func _open_dialogue_view(id: String) -> void:
	var dv := DialogueView.new()
	add_child(dv)
	dv.finished.connect(_on_dialogue_finished.bind(id))
	dv.start(Story.get_dialogue(id))


## Fin de una mini-escena. Si encadena diálogo (búsquedas de casos reales), lo abre
## a continuación (sigue "ocupado"; _on_dialogue_finished limpiará el estado). Si no
## (tutorial, presentar, deducir), cierra como siempre.
func _on_interaction_finished(result: Dictionary, id: String) -> void:
	if Story.interact_data(id).get("then_dialogue", false):
		_open_dialogue_view(id)
	else:
		_on_dialogue_finished(result, id)


func _make_interaction(d: Dictionary) -> Control:
	match String(d.get("type", "")):
		"search":  return SearchView.new()
		"examine": return ExamineView.new()
		"puzzle":  return PuzzleView.new()
		"present": return PresentView.new()
		"deduce":  return DeduceView.new()
	return null


func _on_dialogue_finished(result: Dictionary, _id: String) -> void:
	_busy = false
	_set_pins_enabled(true)
	Music.play_mood(_map_mood())        # de vuelta al ambiente del mapa
	# ¿Se ha cerrado el capítulo? Al terminarlo mostramos el panel de apoyo (Ko-fi)
	# y, al continuar, avanzamos al siguiente capítulo (o cerramos si era el último).
	if Global.has_flag(Story.end_flag()):
		var kofi_flag := "kofi_%d" % Global.chapter
		# El capítulo 0 es el tutorial: no interrumpimos con el panel de apoyo ahí.
		if Global.chapter >= 1 and not Global.has_flag(kofi_flag):
			Global.set_flag(kofi_flag, true)
			var was_last := Story.is_last_chapter()
			_show_kofi_support(func() -> void:
				if not was_last:
					_advance_chapter()
				else:
					_refresh())
			return
		elif not Story.is_last_chapter():
			_advance_chapter()
			return
	_refresh()
	var fc: int = result.get("false_count", 0)
	if result.get("clue") != null and not (result.clue as Dictionary).get("false", false):
		_fly_clue_to_notebook(false)
		_show_toast(Global.loc("Pista anotada:  %s") % Global.loc(result.clue.title), Global.COL_WARM)
	elif fc > 0:
		for i in mini(fc, 3):
			_fly_clue_to_notebook(true, i * 0.12)
		var msg := (Global.loc("%d pistas falsas · descartadas") % fc) if fc > 1 else Global.loc("Pista falsa · descartada")
		_show_toast(msg, Color(0.85, 0.45, 0.45))
	elif String(result.get("flag", "")) == Story.complete_flag():
		_show_toast(Global.loc("Caso resuelto."), Color(0.6, 0.9, 0.65))


## Pide confirmación antes de saltar el tutorial (evita saltos accidentales).
## Overlay propio, con el mismo lenguaje que el resto de paneles del juego (fondo
## atenuado + panel oscuro con borde de acento): un ConfirmationDialog sale con el
## tema por defecto de Godot y desentona con todo lo demás.
func _confirm_skip_tutorial() -> void:
	if _skipped or _advancing:
		return                       # ya se está saltando: no apilar otro diálogo
	# Deshabilita el botón mientras el diálogo está abierto: dos velos a pantalla
	# completa apilados dejarían la entrada bloqueada (el "cuelgue" al saltar).
	if is_instance_valid(_skip_btn):
		_skip_btn.disabled = true
	var layer := Control.new()
	layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	layer.z_index = 120
	add_child(layer)

	var dim := ColorRect.new()
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.color = Color(0, 0, 0, 0.7)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP   # el fondo NO deja tocar el mapa
	layer.add_child(dim)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(center)

	var panel := PanelContainer.new()
	var ps := StyleBoxFlat.new()
	ps.bg_color = Color(0.06, 0.07, 0.10, 0.98)
	ps.set_corner_radius_all(10)
	ps.set_border_width_all(2)
	ps.border_color = Global.COL_ACCENT_DIM
	ps.set_content_margin_all(26)
	panel.add_theme_stylebox_override("panel", ps)
	center.add_child(panel)

	var vb := VBoxContainer.new()
	vb.custom_minimum_size = Vector2(420, 0)
	vb.add_theme_constant_override("separation", 14)
	panel.add_child(vb)

	var head := Label.new()
	head.text = Global.loc("Saltar tutorial")
	head.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
	head.add_theme_font_override("font", Global.font_title)
	head.add_theme_font_size_override("font_size", 26)
	head.add_theme_color_override("font_color", Global.COL_WARM)
	vb.add_child(head)

	var body := Label.new()
	body.text = Global.loc("¿Saltar el tutorial y empezar el primer caso?")
	body.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.add_theme_font_size_override("font_size", 15)
	body.add_theme_color_override("font_color", Global.COL_TEXT)
	vb.add_child(body)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	vb.add_child(row)

	var back := _mini_button("Seguir", func() -> void:
		layer.queue_free()
		if is_instance_valid(_skip_btn):
			_skip_btn.disabled = false)
	back.custom_minimum_size = Vector2(150, 40)
	row.add_child(back)

	var go := _mini_button("Saltar", func() -> void:
		layer.queue_free()
		_skip_tutorial())
	go.custom_minimum_size = Vector2(150, 40)
	row.add_child(go)


## Panel de APOYO (Ko-fi) al cerrar un capítulo. Mantiene el lenguaje visual del juego
## (fondo atenuado + panel oscuro con borde de acento, tipografía de título) para que la
## invitación a donar quede integrada y no como un anuncio. Al pulsar "Continuar" ejecuta
## el callback recibido (avanzar de capítulo o refrescar si era el último).
const KOFI_URL := "https://ko-fi.com/josepsola"

func _show_kofi_support(on_continue: Callable) -> void:
	Global.play_sfx(Global.SFX_NOTE, -6.0)

	var layer := Control.new()
	layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	layer.z_index = 130
	add_child(layer)

	var dim := ColorRect.new()
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.color = Color(0, 0, 0, 0.78)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	layer.add_child(dim)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(center)

	var panel := PanelContainer.new()
	var ps := StyleBoxFlat.new()
	ps.bg_color = Color(0.05, 0.06, 0.09, 0.99)
	ps.set_corner_radius_all(12)
	ps.border_width_left = 4
	ps.border_width_top = 1
	ps.border_width_right = 1
	ps.border_width_bottom = 1
	ps.border_color = Global.COL_WARM
	ps.set_content_margin_all(30)
	ps.shadow_color = Color(0, 0, 0, 0.8)
	ps.shadow_size = 26
	panel.add_theme_stylebox_override("panel", ps)
	center.add_child(panel)

	var vb := VBoxContainer.new()
	vb.custom_minimum_size = Vector2(468, 0)
	vb.add_theme_constant_override("separation", 16)
	panel.add_child(vb)

	var mark := Label.new()
	mark.text = "☕"
	mark.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
	mark.add_theme_font_size_override("font_size", 44)
	vb.add_child(mark)

	var head := Label.new()
	head.text = Global.loc("Fin del capítulo")
	head.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
	head.add_theme_font_override("font", Global.font_title)
	head.add_theme_font_size_override("font_size", 28)
	head.add_theme_color_override("font_color", Global.COL_WARM)
	vb.add_child(head)

	var body := Label.new()
	body.text = Global.loc("Gracias por jugar a sOC. Este caso avanza gracias a quienes lo apoyan. Si te está gustando la investigación, puedes invitarme a un café: mantiene viva la ciudad y sus misterios.")
	body.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.add_theme_font_size_override("font_size", 15)
	body.add_theme_color_override("font_color", Global.COL_TEXT)
	vb.add_child(body)

	var link := Label.new()
	link.text = KOFI_URL
	link.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
	link.add_theme_font_size_override("font_size", 13)
	link.add_theme_color_override("font_color", Global.COL_ACCENT)
	vb.add_child(link)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	vb.add_child(row)

	var donate := _mini_button("☕  Invítame un café", func() -> void:
		OS.shell_open(KOFI_URL))
	donate.custom_minimum_size = Vector2(210, 44)
	# Resaltar el botón de donar con el color cálido de marca.
	var db := StyleBoxFlat.new()
	db.bg_color = Color(0.20, 0.13, 0.07, 0.96)
	db.set_corner_radius_all(6)
	db.border_width_left = 3
	db.border_color = Global.COL_WARM
	db.set_content_margin_all(8)
	donate.add_theme_stylebox_override("normal", db)
	row.add_child(donate)

	var cont := _mini_button("Continuar", func() -> void:
		layer.queue_free()
		on_continue.call())
	cont.custom_minimum_size = Vector2(150, 44)
	row.add_child(cont)

	panel.modulate.a = 0.0
	panel.scale = Vector2(0.94, 0.94)
	panel.pivot_offset = Vector2(234, 140)
	var t := create_tween().set_parallel(true)
	t.tween_property(panel, "modulate:a", 1.0, 0.25)
	t.tween_property(panel, "scale", Vector2.ONE, 0.3) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


## Marca el tutorial como completado y salta al primer caso real (Cap. 1).
func _skip_tutorial() -> void:
	if _skipped or _advancing:
		return                       # un doble toque no debe saltar dos capítulos
	_skipped = true
	_busy = false                    # por si acaso: que la entrada no quede bloqueada
	Global.set_flag("cap0_completo", true)
	Global.set_flag("done_cierre0", true)
	if is_instance_valid(_skip_btn):
		_skip_btn.visible = false
	_advance_chapter()   # 0 -> 1: reconstruye el mapa y guarda


func _advance_chapter() -> void:
	# Reentrada: un doble toque (o el camino normal + el skip a la vez) podría
	# reconstruir el mapa a media transición y dejar el juego colgado.
	if _advancing:
		return
	_advancing = true
	Global.chapter += 1
	Global.save_game()
	Music.play_mood(_map_mood())   # el nuevo capítulo puede oscurecer el ambiente
	# Limpiar los pines del capítulo anterior.
	for id in _pins:
		_pins[id].btn.queue_free()
		_pins[id].label.queue_free()
	_pins.clear()
	_shown.clear()
	_first_refresh = true
	_current = Vector2(-1, -1)
	_title.text = Global.loc(Story.chapter_title())
	# Mapa propio de la nueva región (si lo tiene).
	if is_instance_valid(_map_bg):
		_map_bg.queue_free()
	_build_map_bg()
	move_child(_map_bg, 0)   # el mapa, al fondo
	_build_pins()
	call_deferred("_relayout")
	call_deferred("_refresh")
	_show_toast(Global.loc("Nuevo caso: %s") % Global.loc(Story.chapter_title()), Color(0.40, 0.90, 0.98))
	_advancing = false


# ---------------------------------------------------------------------------
#  ANIMACIÓN: la pista vuela desde el centro (la escena) hasta la libreta
# ---------------------------------------------------------------------------
func _fly_clue_to_notebook(is_false: bool, delay: float = 0.0) -> void:
	if not is_instance_valid(_nb_btn):
		return
	var cs := Vector2(78, 92)
	# El elemento que vuela es el ICONO de la libreta, difuminado (semitransparente).
	var card := TextureRect.new()
	if ResourceLoader.exists("res://assets/ui/ic_libreta.png"):
		card.texture = load("res://assets/ui/ic_libreta.png")
	card.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	card.custom_minimum_size = cs
	card.size = cs
	card.pivot_offset = cs * 0.5
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.z_index = 30
	# Teñido: rojo para falsas, natural (ámbar del icono) para buenas. Alfa 0 -> aparece luego.
	card.modulate = Color(1.0, 0.55, 0.55, 0.0) if is_false else Color(1.0, 1.0, 1.0, 0.0)
	var mark := Label.new()
	mark.text = "✗" if is_false else "✓"
	mark.add_theme_font_size_override("font_size", 30)
	mark.add_theme_color_override("font_color", Color(1.0, 0.55, 0.55) if is_false else Global.COL_WARM)
	mark.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
	mark.add_theme_constant_override("outline_size", 5)
	mark.set_anchors_preset(Control.PRESET_FULL_RECT)
	mark.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mark.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	mark.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(mark)
	var vp := get_viewport_rect().size
	card.position = vp * 0.5 - cs * 0.5
	add_child(card)
	# Aterriza CENTRADO sobre el botón de la libreta (rect real, no la posición cruda),
	# y un poco más arriba para que quede claramente ENCIMA del botón, no debajo-derecha.
	var target := _nb_btn.get_global_rect().get_center() - cs * 0.5 - Vector2(42.0, cs.y * 0.18)
	var t := create_tween()
	if delay > 0.0:
		t.tween_interval(delay)
	# 1) aparece difuminado en el centro
	t.tween_property(card, "modulate:a", 0.75, 0.14)
	# 2) vuela hasta la libreta SIN desvanecerse por el camino: llega de verdad
	t.tween_property(card, "position", target, 0.60).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	# Encoge más al llegar para que quede DENTRO del botón de la libreta (antes sobresalía).
	t.parallel().tween_property(card, "scale", Vector2(0.34, 0.34), 0.60)
	# 3) al LLEGAR a la libreta: pulso del icono (solo pistas buenas) y se desvanece ahí mismo
	if not is_false:
		t.tween_callback(_pulse_notebook)
	t.tween_property(card, "modulate:a", 0.0, 0.16)
	t.tween_callback(card.queue_free)


func _pulse_notebook() -> void:
	if not is_instance_valid(_nb_btn):
		return
	Global.play_sfx(Global.SFX_CONFIRM, -8.0)
	_nb_btn.pivot_offset = _nb_btn.size * 0.5
	var t := create_tween()
	t.tween_property(_nb_btn, "scale", Vector2(1.3, 1.3), 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t.tween_property(_nb_btn, "scale", Vector2(1, 1), 0.22).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)


func _set_pins_enabled(on: bool) -> void:
	for id in _pins:
		_pins[id].btn.disabled = not on


func _loc_name(id: String) -> String:
	for l in Story.locations():
		if l.id == id:
			return l.name
	return id


# ---------------------------------------------------------------------------
#  LIBRETA DE PISTAS
# ---------------------------------------------------------------------------
func _build_notebook() -> void:
	_notebook = Panel.new()
	_notebook.set_anchors_preset(Control.PRESET_CENTER)
	_notebook.anchor_left = 0.5
	_notebook.anchor_right = 0.5
	_notebook.anchor_top = 0.5
	_notebook.anchor_bottom = 0.5
	_notebook.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_notebook.grow_vertical = Control.GROW_DIRECTION_BOTH
	_notebook.custom_minimum_size = Vector2(560, 440)
	_notebook.offset_left = -280
	_notebook.offset_right = 280
	_notebook.offset_top = -220
	_notebook.offset_bottom = 220
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.06, 0.07, 0.10, 0.98)
	sb.set_corner_radius_all(10)
	sb.border_width_left = 3
	sb.border_width_top = 3
	sb.border_width_right = 3
	sb.border_width_bottom = 3
	sb.border_color = Global.COL_ACCENT
	sb.set_content_margin_all(24)
	_notebook.add_theme_stylebox_override("panel", sb)
	_notebook.visible = false
	add_child(_notebook)

	# Contenido con scroll y márgenes (las pistas ya no se salen).
	var scroll := ScrollContainer.new()
	scroll.set_anchors_preset(Control.PRESET_FULL_RECT)
	scroll.offset_left = 30
	scroll.offset_top = 26
	scroll.offset_right = -22
	scroll.offset_bottom = -64
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_notebook.add_child(scroll)

	var vb := VBoxContainer.new()
	vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(vb)

	_notebook_label = Label.new()
	_notebook_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_notebook_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	Global.style_dialogue(_notebook_label, 18)
	vb.add_child(_notebook_label)

	var close := _mini_button("Cerrar", func() -> void: _toggle_notebook(), "res://assets/ui/ic_close.png")
	close.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	close.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	close.grow_vertical = Control.GROW_DIRECTION_BEGIN
	close.offset_left = -60
	close.offset_top = -52
	_notebook.add_child(close)


func _toggle_notebook() -> void:
	# Abre/cierra el TABLERO de pistas dinámico (EvidenceBoard).
	if is_instance_valid(_board):
		_board.queue_free()
		_board = null
		return
	Global.play_sfx(Global.SFX_NOTE, -2.0)
	_board = EvidenceBoard.new()
	_board.z_index = 110
	_board.case_closed.connect(_on_board_case_closed)
	add_child(_board)


## El jugador ha atado todas las pistas en el tablero: el caso está cerrado. El
## tablero ya se cierra solo; aquí encadenamos el EPÍLOGO (la comisaría, en el
## Cap. 1), cuyo diálogo activa el end_flag y dispara el salto de capítulo por la
## vía de siempre (_on_dialogue_finished). Los capítulos sin epílogo no llegan
## aquí: su tablero no se juega.
func _on_board_case_closed() -> void:
	_board = null
	var id := Story.epilogue_id()
	if id == "" or _busy:
		return
	_busy = true
	_set_pins_enabled(false)
	_open_dialogue_view(id)


func _refresh_notebook() -> void:
	var reales: Array = []
	var falsas: Array = []
	for c in Global.clues:
		if c.get("false", false):
			falsas.append(c)
		else:
			reales.append(c)
	var t := (Global.loc("LIBRETA DE PISTAS   (%d)") % reales.size()) + "\n\n"
	if reales.is_empty():
		t += Global.loc("Aún no has anotado pistas.\nSigue el hilo de la investigación.")
	else:
		for c in reales:
			t += "•  %s\n     %s\n\n" % [Global.loc(c.title), Global.loc(c.text)]
	if not falsas.is_empty():
		t += "\n" + Global.loc("— PISTAS DESCARTADAS —") + "\n\n"
		for c in falsas:
			t += "✗  %s\n     %s\n\n" % [Global.loc(c.title), Global.loc(c.text)]
	_notebook_label.text = t


# ---------------------------------------------------------------------------
#  AVISO / ENTRADA
# ---------------------------------------------------------------------------
func _show_toast(text: String, color: Color) -> void:
	_toast.text = text
	_toast.add_theme_color_override("font_color", color)
	_toast.modulate.a = 0.0
	var t := create_tween()
	t.tween_property(_toast, "modulate:a", 1.0, 0.25)
	t.tween_interval(1.9)
	t.tween_property(_toast, "modulate:a", 0.0, 0.6)


func _unhandled_input(event: InputEvent) -> void:
	if _busy:
		return
	if event.is_action_pressed("pause"):
		if is_instance_valid(_board):
			_toggle_notebook()
		else:
			Global.change_scene("res://scenes/MainMenu.tscn")
	elif event.is_action_pressed("notebook"):
		_toggle_notebook()


# ---------------------------------------------------------------------------
#  COLOCACION RESPONSIVE
# ---------------------------------------------------------------------------
func _relayout() -> void:
	var vp := get_viewport_rect().size
	for loc in Story.locations():
		var id: String = loc.id
		if not _pins.has(id):
			continue
		var pt := Vector2(loc.pos.x * vp.x, loc.pos.y * vp.y)
		# Mantener los pines dentro de la zona visible (bajo la barra superior).
		pt.y = clampf(pt.y, 96, vp.y - 40)
		pt.x = clampf(pt.x, 40, vp.x - 40)
		var p: Dictionary = _pins[id]
		p.point = pt
		var btn: Button = p.btn
		btn.position = pt - btn.size * 0.5
		var lbl: Label = p.label
		lbl.reset_size()
		lbl.position = Vector2(pt.x - lbl.size.x * 0.5, pt.y + 18)
	if _current.x < 0 and _pins.has("plaza"):
		_current = _pins["plaza"].point
		_token.position = _current - _token.size * 0.5
	_update_coach()


# ===========================================================================
#  MAPA PROCEDURAL DE RESPALDO (mientras no exista assets/backgrounds/mapa.png)
# ===========================================================================
class MapCanvas extends Control:
	func _ready() -> void:
		resized.connect(queue_redraw)

	func _draw() -> void:
		var s := size
		# Fondo tipo plano nocturno
		draw_rect(Rect2(Vector2.ZERO, s), Color(0.06, 0.08, 0.12))
		# Manzanas de edificios
		var block := Color(0.10, 0.12, 0.17)
		var rng := [
			Rect2(0.05, 0.12, 0.16, 0.20), Rect2(0.24, 0.10, 0.14, 0.16),
			Rect2(0.42, 0.14, 0.16, 0.14), Rect2(0.63, 0.10, 0.15, 0.18),
			Rect2(0.82, 0.14, 0.13, 0.20), Rect2(0.06, 0.40, 0.15, 0.22),
			Rect2(0.24, 0.44, 0.16, 0.20), Rect2(0.44, 0.42, 0.14, 0.22),
			Rect2(0.64, 0.46, 0.16, 0.18), Rect2(0.82, 0.44, 0.13, 0.22),
			Rect2(0.10, 0.70, 0.18, 0.20), Rect2(0.34, 0.72, 0.16, 0.18),
			Rect2(0.56, 0.72, 0.16, 0.20), Rect2(0.76, 0.70, 0.16, 0.20),
		]
		for r in rng:
			var rr := Rect2(r.position * s, r.size * s)
			draw_rect(rr, block)
			draw_rect(rr, Color(0.16, 0.18, 0.24), false, 2.0)
		# Avenidas (cruz + diagonal) tipo "hilo de detective"
		var road := Color(0.20, 0.22, 0.30)
		draw_line(Vector2(0, s.y * 0.36), Vector2(s.x, s.y * 0.36), road, 10.0)
		draw_line(Vector2(0, s.y * 0.66), Vector2(s.x, s.y * 0.66), road, 8.0)
		draw_line(Vector2(s.x * 0.50, 0), Vector2(s.x * 0.50, s.y), road, 10.0)
		draw_line(Vector2(s.x * 0.18, s.y), Vector2(s.x * 0.82, 0), road.lerp(Color(0.24,0.20,0.26),0.5), 6.0)
		# Parque junto a la iglesia (norte)
		draw_circle(Vector2(s.x * 0.5, s.y * 0.16), s.y * 0.10, Color(0.10, 0.18, 0.14))
