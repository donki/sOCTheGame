extends Control
class_name SearchView
## Mecanica 1 — BUSQUEDA DE PISTAS por el escenario (hotspots).
## El jugador examina el fondo tocando zonas marcadas (aros ambar pulsantes).
## Al tocar la zona correcta (target) se revela la pista y la escena termina,
## aplicando el contrato (add_clue + set_flag + finished).
##
## Uso:
##   var sv := SearchView.new()
##   add_child(sv)
##   sv.finished.connect(_on_search_finished)
##   sv.start({...})   # ver forma de `data` en el spec

signal finished(result: Dictionary)

var _data: Dictionary = {}
var _hotspots: Array = []      # Botones circulares (uno por zona)
var _found := 0                # zonas fallidas ya investigadas (para el contador)
var _total := 0                # total de zonas
var _done := false             # evita dobles disparos

# Revelado por tiempo: las marcas NO se ven al principio (búsqueda real). Si el
# jugador no encuentra la zona, a 1 min pasan a 15% de opacidad (85% transp.) y a
# 2 min a 20% (80% transp.). Sin más "pistas".
var _elapsed := 0.0
var _rev1 := false
var _rev2 := false
const REVEAL_A1 := 0.15
const REVEAL_A2 := 0.20

# Nodos
var _bg: TextureRect
var _intro: Label
var _counter: Label
var _toast: Panel
var _toast_label: Label
var _reveal: Panel

# Lupa que sigue al puntero + destello que parpadea al pasar sobre una zona.
var _lens: Control
var _glint: Control


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP


func start(data: Dictionary) -> void:
	_data = data
	_build_ui()
	# Aparicion suave
	modulate.a = 0.0
	var t := create_tween()
	t.tween_property(self, "modulate:a", 1.0, 0.35)


# ---------------------------------------------------------------------------
#  CONSTRUCCION DE LA UI
# ---------------------------------------------------------------------------
func _build_ui() -> void:
	# Fondo de gradiente de respaldo
	var grad := ColorRect.new()
	grad.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	grad.color = Global.COL_BG_BOTTOM
	grad.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(grad)

	# Fondo (imagen del escenario) si existe
	_bg = TextureRect.new()
	_bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var path := "res://assets/backgrounds/%s.png" % _data.get("bg", "plaza")
	if ResourceLoader.exists(path):
		_bg.texture = load(path)
	add_child(_bg)

	# Velo oscuro para legibilidad
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

	# Cartel de instruccion (arriba)
	var bar := Panel.new()
	bar.set_anchors_preset(Control.PRESET_TOP_WIDE)
	bar.offset_left = 40
	bar.offset_right = -40
	bar.offset_top = 28
	bar.offset_bottom = 96
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bar.add_theme_stylebox_override("panel", _panel_style())
	add_child(bar)

	_intro = Label.new()
	_intro.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_intro.offset_left = 20
	_intro.offset_right = -20
	_intro.text = Global.loc(String(_data.get("intro", "Examina el escenario. Toca lo que te llame la atención.")))
	_intro.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_intro.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_intro.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_intro.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_style_text(_intro, 20, Global.COL_TEXT)
	bar.add_child(_intro)

	# Contador "pistas encontradas / zonas investigadas"
	var hotspots: Array = _data.get("hotspots", [])
	_total = hotspots.size()
	_counter = Label.new()
	_counter.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_counter.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	_counter.offset_left = -320
	_counter.offset_right = -48
	_counter.offset_top = 104
	_counter.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_counter.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_style_text(_counter, 16, Global.COL_WARM)
	add_child(_counter)
	_update_counter()

	# Hotspots (aros ambar pulsantes)
	for h in hotspots:
		_add_hotspot(h)

	# Toast (feedback abajo) — oculto por defecto
	_toast = Panel.new()
	_toast.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	_toast.anchor_left = 0.5
	_toast.anchor_right = 0.5
	_toast.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_toast.offset_top = -150
	_toast.offset_bottom = -80
	_toast.custom_minimum_size = Vector2(520, 60)
	_toast.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_toast.add_theme_stylebox_override("panel", _panel_style(Global.COL_ACCENT))
	_toast.modulate.a = 0.0
	add_child(_toast)

	_toast_label = Label.new()
	_toast_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_toast_label.offset_left = 20
	_toast_label.offset_right = -20
	_toast_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_toast_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_toast_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_toast_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_style_text(_toast_label, 17, Global.COL_TEXT)
	_toast.add_child(_toast_label)

	# Lupa (por encima de todo) — la última, para que quede sobre hotspots y carteles.
	_build_lens()


func _add_hotspot(h: Dictionary) -> void:
	var pos: Vector2 = h.get("pos", Vector2(0.5, 0.5))
	var r: float = float(h.get("r", 64))
	var b := Button.new()
	b.flat = true
	# Colocacion normalizada (independiente de la resolucion): anclamos el centro
	# a `pos` y damos un tamano 2r x 2r con offsets simetricos.
	b.anchor_left = pos.x
	b.anchor_right = pos.x
	b.anchor_top = pos.y
	b.anchor_bottom = pos.y
	b.grow_horizontal = Control.GROW_DIRECTION_BOTH
	b.grow_vertical = Control.GROW_DIRECTION_BOTH
	b.offset_left = -r
	b.offset_right = r
	b.offset_top = -r
	b.offset_bottom = r
	b.pivot_offset = Vector2(r, r)   # pulso desde el centro
	b.focus_mode = Control.FOCUS_NONE
	# Aro ambar circular (radio de esquina = r -> circulo perfecto).
	var ring := _ring_style(r)
	b.add_theme_stylebox_override("normal", ring)
	b.add_theme_stylebox_override("hover", _ring_style(r, true))
	b.add_theme_stylebox_override("pressed", _ring_style(r, true))
	b.add_theme_stylebox_override("focus", ring)
	b.set_meta("target", bool(h.get("target", false)))
	b.set_meta("text", String(h.get("text", "")))
	b.set_meta("r", r)
	b.pressed.connect(_on_hotspot.bind(b))
	# El punto empieza al 10% de opacidad (90% transp.); a 1 min sube a 15% y a 2 min a 20%.
	# En el TUTORIAL (show_marks) se ven al 100% para enseñar la mecánica.
	b.modulate.a = 1.0 if bool(_data.get("show_marks", false)) else 0.10
	add_child(b)
	# Punto sutil y brillante en el centro (marca la zona sin destacar como un "?").
	var dot := Panel.new()
	var dd := r * 0.42
	dot.set_anchors_preset(Control.PRESET_CENTER)
	dot.offset_left = -dd * 0.5
	dot.offset_top = -dd * 0.5
	dot.offset_right = dd * 0.5
	dot.offset_bottom = dd * 0.5
	dot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var ds := StyleBoxFlat.new()
	ds.bg_color = Color(Global.COL_WARM.r, Global.COL_WARM.g, Global.COL_WARM.b, 0.10)
	ds.set_corner_radius_all(int(dd))
	ds.shadow_color = Color(Global.COL_WARM.r, Global.COL_WARM.g, Global.COL_WARM.b, 0.10)
	ds.shadow_size = 6
	dot.add_theme_stylebox_override("panel", ds)
	b.add_child(dot)
	_hotspots.append(b)
	# Pulso en bucle (escala 1.0 -> 1.14 -> 1.0)
	var pulse := create_tween().set_loops()
	pulse.tween_property(b, "scale", Vector2(1.14, 1.14), 0.7) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	pulse.tween_property(b, "scale", Vector2(1.0, 1.0), 0.7) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	b.set_meta("pulse", pulse)


# ---------------------------------------------------------------------------
#  INTERACCION
# ---------------------------------------------------------------------------
func _on_hotspot(b: Button) -> void:
	if _done or b.disabled:
		return
	if bool(b.get_meta("target", false)):
		_on_correct(b)
	else:
		_on_wrong(b)


func _on_correct(b: Button) -> void:
	_done = true
	Global.play_sfx(Global.SFX_CONFIRM, -4.0)
	# Detener pulsos y bloquear el resto de zonas
	for hs in _hotspots:
		(hs.get_meta("pulse") as Tween).kill()
		hs.disabled = true
	# Pequeno "pop" de acierto sobre la zona encontrada
	b.scale = Vector2(1.0, 1.0)
	var pop := create_tween()
	pop.tween_property(b, "scale", Vector2(1.3, 1.3), 0.18) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_show_reveal()


func _on_wrong(b: Button) -> void:
	Global.play_sfx(Global.SFX_BACK, -4.0)
	# Atenuar y desactivar esta zona
	b.disabled = true
	(b.get_meta("pulse") as Tween).kill()
	var t := create_tween()
	t.tween_property(b, "scale", Vector2(1.0, 1.0), 0.15)
	t.parallel().tween_property(b, "modulate", Color(0.5, 0.5, 0.55, 0.45), 0.25)
	_found += 1
	_update_counter()
	_show_toast(String(b.get_meta("text", "Nada util aqui.")))


## Lupa: círculo de cristal con aro de latón + mango, que hace de puntero. En su
## centro, un destello que parpadea (oculto salvo cuando se pasa sobre una zona).
func _build_lens() -> void:
	var D := 108.0
	_lens = Control.new()
	_lens.custom_minimum_size = Vector2(D, D)
	_lens.size = Vector2(D, D)
	_lens.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_lens.z_index = 60
	add_child(_lens)

	# Mango (asa) saliendo hacia abajo-derecha (se dibuja primero, tras el cristal).
	var handle := Panel.new()
	handle.size = Vector2(46, 13)
	handle.position = Vector2(D * 0.80, D * 0.80)
	handle.rotation = deg_to_rad(45)
	handle.pivot_offset = Vector2(0, 8)
	handle.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var hs := StyleBoxFlat.new()
	hs.bg_color = Color(0.28, 0.20, 0.11)
	hs.set_corner_radius_all(7)
	hs.set_border_width_all(2)
	hs.border_color = Color(0.85, 0.80, 0.68, 0.9)
	handle.add_theme_stylebox_override("panel", hs)
	_lens.add_child(handle)

	# Cristal: círculo casi transparente con aro grueso de latón.
	var glass := Panel.new()
	glass.size = Vector2(D, D)
	glass.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var gs := StyleBoxFlat.new()
	gs.bg_color = Color(0.78, 0.86, 0.96, 0.06)
	gs.set_corner_radius_all(int(D * 0.5))
	gs.set_border_width_all(6)
	gs.border_color = Color(0.86, 0.80, 0.66, 0.95)
	gs.shadow_color = Color(0, 0, 0, 0.5)
	gs.shadow_size = 8
	glass.add_theme_stylebox_override("panel", gs)
	_lens.add_child(glass)

	# Destello en el centro (parpadeo suave en bucle; visible solo sobre una zona).
	_glint = Panel.new()
	var gd := 20.0
	_glint.size = Vector2(gd, gd)
	_glint.position = Vector2(D * 0.5 - gd * 0.5, D * 0.5 - gd * 0.5)
	_glint.pivot_offset = Vector2(gd * 0.5, gd * 0.5)
	_glint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var gls := StyleBoxFlat.new()
	gls.bg_color = Color(1.0, 0.96, 0.78, 0.95)
	gls.set_corner_radius_all(int(gd * 0.5))
	gls.shadow_color = Color(1.0, 0.90, 0.60, 0.8)
	gls.shadow_size = 14
	_glint.add_theme_stylebox_override("panel", gls)
	_glint.visible = false
	_lens.add_child(_glint)
	var tw := create_tween().set_loops()
	tw.tween_property(_glint, "modulate:a", 0.25, 0.55).set_trans(Tween.TRANS_SINE)
	tw.parallel().tween_property(_glint, "scale", Vector2(0.7, 0.7), 0.55).set_trans(Tween.TRANS_SINE)
	tw.tween_property(_glint, "modulate:a", 1.0, 0.55).set_trans(Tween.TRANS_SINE)
	tw.parallel().tween_property(_glint, "scale", Vector2(1.12, 1.12), 0.55).set_trans(Tween.TRANS_SINE)

	# La lupa ES el puntero: se oculta el cursor del sistema mientras dura la escena.
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


## ¿El puntero está sobre alguna zona (hotspot) aún investigable?
func _over_hotspot(m: Vector2) -> bool:
	for b in _hotspots:
		if is_instance_valid(b) and not b.disabled and b.get_global_rect().has_point(m):
			return true
	return false


func _exit_tree() -> void:
	# Por si se cierra la escena por otra vía: devolver el cursor del sistema.
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _process(delta: float) -> void:
	# La lupa sigue al puntero y su destello se enciende sobre una zona.
	if _lens != null:
		var m := get_global_mouse_position()
		_lens.position = m - _lens.size * 0.5
		_glint.visible = not _done and _over_hotspot(m)
	# Revelado gradual por tiempo (solo si aún no se ha encontrado).
	if _done:
		return
	_elapsed += delta
	if not _rev1 and _elapsed >= 60.0:
		_rev1 = true
		_reveal_marks(REVEAL_A1)
	elif not _rev2 and _elapsed >= 120.0:
		_rev2 = true
		_reveal_marks(REVEAL_A2)


func _reveal_marks(a: float) -> void:
	for hs in _hotspots:
		if hs.disabled:
			continue   # las zonas ya investigadas conservan su estado atenuado
		var t := create_tween()
		t.tween_property(hs, "modulate:a", a, 0.6)


func _update_counter() -> void:
	_counter.text = Global.loc("Zonas investigadas") + ": %d/%d" % [_found, _total]


func _show_toast(text: String) -> void:
	_toast_label.text = Global.loc(text)
	_toast.modulate.a = 0.0
	var t := create_tween()
	t.tween_property(_toast, "modulate:a", 1.0, 0.2)
	t.tween_interval(2.2)
	t.tween_property(_toast, "modulate:a", 0.0, 0.4)


# ---------------------------------------------------------------------------
#  REVELACION + FIN (contrato)
# ---------------------------------------------------------------------------
func _show_reveal() -> void:
	_reveal = Panel.new()
	_reveal.set_anchors_preset(Control.PRESET_CENTER)
	_reveal.anchor_left = 0.5
	_reveal.anchor_right = 0.5
	_reveal.anchor_top = 0.5
	_reveal.anchor_bottom = 0.5
	_reveal.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_reveal.grow_vertical = Control.GROW_DIRECTION_BOTH
	_reveal.custom_minimum_size = Vector2(640, 300)
	_reveal.add_theme_stylebox_override("panel", _panel_style())
	_reveal.modulate.a = 0.0
	add_child(_reveal)

	var vb := VBoxContainer.new()
	vb.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	vb.offset_left = 32
	vb.offset_top = 28
	vb.offset_right = -32
	vb.offset_bottom = -28
	vb.add_theme_constant_override("separation", 16)
	_reveal.add_child(vb)

	var header := Label.new()
	header.text = Global.loc(String(_data.get("reveal", "¡Una pista! Se guarda en tu libreta.")))
	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	header.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_style_text(header, 22, Global.COL_WARM)
	vb.add_child(header)

	var clue: Dictionary = _data.get("clue", {})
	if not clue.is_empty():
		var title := Label.new()
		title.text = "· " + Global.loc(String(clue.get("title", ""))) + " ·"
		title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		_style_text(title, 18, Global.COL_TEXT)
		vb.add_child(title)

		var body := Label.new()
		body.text = Global.loc(String(clue.get("text", "")))
		body.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_style_text(body, 16, Global.COL_TEXT_MUTED)
		vb.add_child(body)

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vb.add_child(spacer)

	var cont := Button.new()
	cont.text = Global.loc("Continuar")
	cont.custom_minimum_size = Vector2(220, 48)
	cont.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	cont.add_theme_font_size_override("font_size", 18)
	cont.add_theme_color_override("font_color", Global.COL_TEXT)
	var csb := _panel_style()
	cont.add_theme_stylebox_override("normal", csb)
	cont.add_theme_stylebox_override("hover", _panel_style(Global.COL_TEXT))
	cont.add_theme_stylebox_override("pressed", _panel_style(Global.COL_TEXT))
	cont.pressed.connect(_finish)
	vb.add_child(cont)

	var t := create_tween()
	t.tween_property(_reveal, "modulate:a", 1.0, 0.25)


func _finish() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)   # recupera el cursor del sistema
	var result := {"clue": null, "flag": "", "false_count": 0}
	if _data.has("clue"):
		var cl: Dictionary = _data.clue
		Global.add_clue(cl.title, cl.text, cl.get("false", false))
		result.clue = cl
		if cl.get("false", false):
			result.false_count = 1
	if _data.has("flag"):
		Global.set_flag(String(_data.flag), true)
		result.flag = _data.flag
	var t := create_tween()
	t.tween_property(self, "modulate:a", 0.0, 0.3)
	await t.finished
	finished.emit(result)
	queue_free()


# ---------------------------------------------------------------------------
#  ESTILOS
# ---------------------------------------------------------------------------
func _panel_style(border: Color = Global.COL_WARM) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.10, 0.09, 0.12, 0.95)
	sb.set_corner_radius_all(8)
	sb.set_border_width_all(2)
	sb.border_color = border
	sb.set_content_margin_all(12)
	return sb


func _ring_style(r: float, bright: bool = false) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(Global.COL_WARM.r, Global.COL_WARM.g, Global.COL_WARM.b, 0.18 if bright else 0.10)
	sb.set_corner_radius_all(int(r))
	sb.set_border_width_all(4 if bright else 3)
	sb.border_color = Color(1, 1, 1, 1) if bright else Global.COL_WARM
	return sb


func _style_text(l: Label, size: int, color: Color) -> void:
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
	l.add_theme_constant_override("outline_size", 4)
