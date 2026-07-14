extends Control
class_name PresentView
## Mecánica 2 — PRESENTAR PRUEBA / pillar la contradicción (estilo Ace Attorney).
## Overlay a pantalla completa sobre el mapa. Dos fases:
##   1) el sospechoso suelta varias frases; el jugador toca la que MIENTE.
##   2) se abre la libreta de pistas; el jugador toca la que desmiente la mentira.
## Aciertos → refutación + termina (contrato). Fallos → pista de ayuda, sin bloquear.
##
## Uso:
##   var pv := PresentView.new()
##   add_child(pv)
##   pv.finished.connect(_on_finished)
##   pv.start(Story.get_present("l0c"))

signal finished(result: Dictionary)

var _data: Dictionary = {}
var _phase := 1                # 1 = elegir mentira · 2 = elegir pista
var _finished := false

# Nodos
var _bg: TextureRect
var _banner: Label
var _speaker_plate: Panel
var _speaker_label: Label
var _list: VBoxContainer
var _toast: Label


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	_build_ui()


func start(data: Dictionary) -> void:
	_data = data
	Global.note_char(String(data.get("speaker", "")))   # el interrogado va al tablero
	_apply_bg(String(data.get("bg", "plaza")))
	_speaker_label.text = Global.loc(_speaker_name())
	_build_phase1()
	# Aparición suave
	modulate.a = 0.0
	var t := create_tween()
	t.tween_property(self, "modulate:a", 1.0, 0.35)


func _speaker_name() -> String:
	# El dato trae la clave del hablante; el rótulo visible es "Sospechoso".
	return "Sospechoso"


# ---------------------------------------------------------------------------
#  CONSTRUCCIÓN DE LA UI
# ---------------------------------------------------------------------------
func _build_ui() -> void:
	# Fondo (base opaca + imagen + velo)
	var base := ColorRect.new()
	base.set_anchors_preset(Control.PRESET_FULL_RECT)
	base.color = Color(Global.COL_BG_BOTTOM.r, Global.COL_BG_BOTTOM.g, Global.COL_BG_BOTTOM.b, 1.0)
	base.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(base)
	_bg = TextureRect.new()
	_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	_bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_bg)

	# Velo oscuro para legibilidad
	var veil := ColorRect.new()
	veil.set_anchors_preset(Control.PRESET_FULL_RECT)
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

	# Cartel de instrucción (arriba)
	var banner_box := Panel.new()
	banner_box.set_anchors_preset(Control.PRESET_TOP_WIDE)
	banner_box.offset_left = 40
	banner_box.offset_right = -40
	banner_box.offset_top = 28
	banner_box.offset_bottom = 96
	var bsb := StyleBoxFlat.new()
	bsb.bg_color = Color(0.10, 0.09, 0.12, 0.95)
	bsb.set_corner_radius_all(8)
	bsb.set_border_width_all(2)
	bsb.border_color = Global.COL_WARM
	bsb.set_content_margin_all(12)
	banner_box.add_theme_stylebox_override("panel", bsb)
	add_child(banner_box)

	_banner = Label.new()
	_banner.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_banner.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_banner.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_banner.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_banner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_banner.add_theme_font_size_override("font_size", 20)
	_banner.add_theme_color_override("font_color", Global.COL_WARM)
	_banner.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	_banner.add_theme_constant_override("outline_size", 4)
	banner_box.add_child(_banner)

	# Placa del hablante (sobre la lista)
	_speaker_plate = Panel.new()
	_speaker_plate.set_anchors_preset(Control.PRESET_CENTER_TOP)
	_speaker_plate.anchor_left = 0.5
	_speaker_plate.anchor_right = 0.5
	_speaker_plate.offset_top = 120
	_speaker_plate.offset_left = -140
	_speaker_plate.offset_right = 140
	_speaker_plate.custom_minimum_size = Vector2(0, 40)
	_speaker_plate.grow_horizontal = Control.GROW_DIRECTION_BOTH
	var ssb := StyleBoxFlat.new()
	ssb.bg_color = Color(0.10, 0.09, 0.12, 0.98)
	ssb.set_corner_radius_all(6)
	ssb.border_width_bottom = 3
	ssb.border_color = Global.COL_ACCENT
	ssb.set_content_margin_all(6)
	_speaker_plate.add_theme_stylebox_override("panel", ssb)
	add_child(_speaker_plate)

	_speaker_label = Label.new()
	_speaker_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_speaker_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_speaker_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_speaker_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_speaker_label.add_theme_font_override("font", Global.font_title)
	_speaker_label.add_theme_font_size_override("font_size", 20)
	_speaker_label.add_theme_color_override("font_color", Global.COL_ACCENT)
	_speaker_plate.add_child(_speaker_label)

	# Lista de opciones (frases / pistas)
	_list = VBoxContainer.new()
	_list.set_anchors_preset(Control.PRESET_CENTER)
	_list.anchor_left = 0.5
	_list.anchor_right = 0.5
	_list.anchor_top = 0.5
	_list.anchor_bottom = 0.5
	_list.offset_left = -360
	_list.offset_right = 360
	_list.offset_top = -40
	_list.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_list.grow_vertical = Control.GROW_DIRECTION_BOTH
	_list.add_theme_constant_override("separation", 14)
	add_child(_list)

	# Toast de feedback (abajo)
	_toast = Label.new()
	_toast.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	_toast.offset_left = 40
	_toast.offset_right = -40
	_toast.offset_top = -120
	_toast.offset_bottom = -40
	_toast.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_toast.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_toast.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_toast.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_toast.add_theme_font_size_override("font_size", 19)
	_toast.add_theme_color_override("font_color", Global.COL_TEXT)
	_toast.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	_toast.add_theme_constant_override("outline_size", 4)
	_toast.modulate.a = 0.0
	add_child(_toast)


func _apply_bg(key: String) -> void:
	var path := "res://assets/backgrounds/%s.png" % key
	if ResourceLoader.exists(path):
		_bg.texture = load(path)


# ---------------------------------------------------------------------------
#  FASE 1 — elegir la MENTIRA
# ---------------------------------------------------------------------------
func _build_phase1() -> void:
	_phase = 1
	_banner.text = Global.loc(String(_data.get("intro", "Toca la frase que es MENTIRA.")))
	_speaker_plate.visible = true
	_clear_list()
	var statements: Array = _data.get("statements", [])
	for st in statements:
		var stmt: Dictionary = st
		var b := _make_option_button("«%s»" % String(stmt.get("text", "")))
		var is_lie: bool = bool(stmt.get("lie", false))
		b.pressed.connect(func() -> void: _on_statement(is_lie))
		_list.add_child(b)


func _on_statement(is_lie: bool) -> void:
	if _finished:
		return
	if is_lie:
		Global.play_sfx(Global.SFX_NOTE, -4.0)
		_flash_toast(Global.loc("¡Ahí! Esa frase es una mentira. Ahora demuéstralo con una pista."), Global.COL_WARM)
		_build_phase2()
	else:
		Global.play_sfx(Global.SFX_BACK, -4.0)
		_flash_toast(Global.loc(String(_data.get("hint_wrong_statement",
			"Esa frase no choca con lo que sabes. Busca la que contradice una pista."))), Global.COL_ACCENT)


# ---------------------------------------------------------------------------
#  FASE 2 — elegir la PISTA que desmiente la mentira
# ---------------------------------------------------------------------------
func _build_phase2() -> void:
	_phase = 2
	_banner.text = Global.loc("Abre la libreta. Toca la PISTA que lo desmiente.")
	_speaker_plate.visible = false
	_clear_list()

	var needed := String(_data.get("evidence_needed", ""))
	var listed := false
	for c in Global.clues:
		var title := String(c.get("title", ""))
		var b := _make_option_button("· %s" % title)
		var ok: bool = title == needed
		b.pressed.connect(func() -> void: _on_evidence(ok))
		_list.add_child(b)
		listed = true

	# Si la libreta está vacía, ofrece igualmente la pista correcta (no bloquear).
	if not listed:
		var b := _make_option_button("· %s" % needed)
		b.pressed.connect(func() -> void: _on_evidence(true))
		_list.add_child(b)


func _on_evidence(is_correct: bool) -> void:
	if _finished:
		return
	if is_correct:
		Global.play_sfx(Global.SFX_CONFIRM, -4.0)
		_flash_toast(Global.loc(String(_data.get("rebuttal", "¡Contradicción!"))), Global.COL_WARM)
		_finish()
	else:
		Global.play_sfx(Global.SFX_BACK, -4.0)
		_flash_toast(Global.loc(String(_data.get("hint_wrong_evidence",
			"Esa pista no desmiente su mentira. Prueba con otra."))), Global.COL_ACCENT)


# ---------------------------------------------------------------------------
#  BOTONES / FEEDBACK
# ---------------------------------------------------------------------------
func _make_option_button(text: String) -> Button:
	var b := Button.new()
	b.text = Global.loc(text)
	b.custom_minimum_size = Vector2(720, 56)
	b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	b.clip_text = false
	b.add_theme_font_size_override("font_size", 19)
	b.add_theme_color_override("font_color", Global.COL_TEXT)
	b.add_theme_color_override("font_hover_color", Color(1, 1, 1))
	b.add_theme_color_override("font_focus_color", Color(1, 1, 1))
	b.add_theme_color_override("font_pressed_color", Color(1, 1, 1))
	var mk := func(active: bool) -> StyleBoxFlat:
		var sb := StyleBoxFlat.new()
		sb.bg_color = Color(0.14, 0.10, 0.11, 0.96) if active else Color(0.10, 0.09, 0.12, 0.95)
		sb.set_corner_radius_all(8)
		sb.set_border_width_all(2)
		sb.border_color = Global.COL_WARM if active else Global.COL_ACCENT_DIM
		sb.set_content_margin_all(14)
		return sb
	b.add_theme_stylebox_override("normal", mk.call(false))
	b.add_theme_stylebox_override("hover", mk.call(true))
	b.add_theme_stylebox_override("focus", mk.call(true))
	b.add_theme_stylebox_override("pressed", mk.call(true))
	return b


func _clear_list() -> void:
	for c in _list.get_children():
		c.queue_free()


## Muestra un mensaje abajo con un pequeño pulso.
func _flash_toast(text: String, color: Color) -> void:
	_toast.text = text
	_toast.add_theme_color_override("font_color", color)
	_toast.scale = Vector2(0.96, 0.96)
	_toast.pivot_offset = _toast.size * 0.5
	var t := create_tween().set_parallel(true)
	t.tween_property(_toast, "modulate:a", 1.0, 0.18)
	t.tween_property(_toast, "scale", Vector2(1, 1), 0.28).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


# ---------------------------------------------------------------------------
#  FIN — contrato obligatorio
# ---------------------------------------------------------------------------
func _finish() -> void:
	if _finished:
		return
	_finished = true
	# Bloquea más entradas mientras se cierra.
	for c in _list.get_children():
		(c as Button).disabled = true
	var result := {"clue": null, "flag": "", "false_count": 0}
	if _data.has("clue"):
		Global.add_clue(_data.clue.title, _data.clue.text, _data.clue.get("false", false))
		result.clue = _data.clue
		if _data.clue.get("false", false):
			result.false_count = 1
	if _data.has("flag"):
		Global.set_flag(String(_data.flag), true)
		result.flag = _data.flag
	# Pausa breve para leer la refutación, luego fundido.
	await get_tree().create_timer(1.1).timeout
	var t := create_tween()
	t.tween_property(self, "modulate:a", 0.0, 0.3)
	await t.finished
	finished.emit(result)
	queue_free()
