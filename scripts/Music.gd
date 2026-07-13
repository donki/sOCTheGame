extends Node
## Motor de MÚSICA GENERATIVA de "sOC the Game" (autoload `Music`).
##
## Sintetiza música de ambiente y misterio en tiempo real (AudioStreamGenerator),
## sin ficheros de audio: pads noir en registro grave, un sub-bajo, una melodía/motivo
## disperso con envolvente de "pluck" tipo campana, y una fina capa de aire/ruido.
## Todo dirigido por datos en `MOODS`: cada escena elige un ambiente con
## `Music.play_mood("...")` y el motor cruza suavemente de uno a otro.
##
## Diseño:
##  - La progresión de acordes se calcula desde el tiempo ABSOLUTO (fase continua),
##    así el crossfade entre acordes es por amplitud y NO produce clics.
##  - El cambio de mood hace un "duck": baja el volumen, intercambia parámetros con el
##    audio en silencio y vuelve a subir (sin cortes audibles).
##  - El volumen sigue el ajuste `music_volume` de Global (da sentido al slider).
##
## Ver constitución (ADR-006 audio procedural). Empieza EN SILENCIO: solo suena cuando
## una escena pide un mood, de modo que la intro (SplashIntro) conserva su audio propio.

const TAU := PI * 2.0
const MIX := 22050.0

# --- Notas (Hz), para leer los acordes con claridad ---
const A1 := 55.0
const AS1 := 58.27
const B1 := 61.74
const C2 := 65.41
const CS2 := 69.30
const D2 := 73.42
const DS2 := 77.78
const E2 := 82.41
const F2 := 87.31
const FS2 := 92.50
const G2 := 98.00
const GS2 := 103.83
const A2 := 110.0
const AS2 := 116.54
const B2 := 123.47
const C3 := 130.81
const CS3 := 138.59
const D3 := 146.83
const DS3 := 155.56
const E3 := 164.81
const F3 := 174.61
const G3 := 196.00
const GS3 := 207.65
const A3 := 220.0
const AS3 := 233.08
const B3 := 246.94
const C4 := 261.63
const D4 := 293.66
const DS4 := 311.13
const E4 := 329.63
const F4 := 349.23
const G4 := 392.00
const GS4 := 415.30
const A4 := 440.0
const AS4 := 466.16
const B4 := 493.88
const C5 := 523.25
const CS5 := 554.37
const D5 := 587.33
const DS5 := 622.25
const E5 := 659.25

# ---------------------------------------------------------------------------
#  AMBIENTES (data-driven). Añadir uno es solo escribir otra entrada aquí.
# ---------------------------------------------------------------------------
#  chords:      progresión de acordes en registro grave (el primero es la raíz/bajo).
#  chord_dur:   segundos por acorde.
#  pad_gain:    presencia del pad armónico.
#  bass_gain:   sub-bajo (raíz una octava por debajo).
#  detune:      ancho de "chorus" (dos osciladores ligeramente desafinados).
#  trem_rate/depth: trémolo lento del pad (respiración).
#  motif:       notas (Hz) de las que sale el motivo/melodía.
#  motif_gain:  presencia del motivo.
#  motif_rate:  segundos MEDIOS entre notas del motivo.
#  motif_decay: caída del "pluck" (grande = campana/piano largo).
#  motif_random:true = notas dispersas al azar (misterio); false = paso melódico.
#  air_gain:    capa de aire/ruido muy filtrado.
const MOODS := {
	# Melancólico noir — menú principal y capítulos tempranos.
	"noir": {
		"chords": [[A2, C3, E3], [D3, F3, A3], [F2, C3, F3], [E2, GS3, B3]],
		"chord_dur": 6.5, "pad_gain": 0.085, "bass_gain": 0.10, "detune": 0.004,
		"trem_rate": 0.20, "trem_depth": 0.28,
		"motif": [A3, C4, D4, E4, G4, A4], "motif_gain": 0.085,
		"motif_rate": 3.6, "motif_decay": 1.4, "motif_random": false, "air_gain": 0.020,
	},
	# Ambiente de investigación — mapa de la ciudad. Suspendido, en evolución.
	"investigacion": {
		"chords": [[A2, E3, B3], [G2, D3, A3], [F2, C3, G3], [E2, B2, E3]],
		"chord_dur": 7.5, "pad_gain": 0.080, "bass_gain": 0.11, "detune": 0.005,
		"trem_rate": 0.16, "trem_depth": 0.30,
		"motif": [E4, G4, A4, B4, D5], "motif_gain": 0.070,
		"motif_rate": 4.8, "motif_decay": 1.9, "motif_random": true, "air_gain": 0.028,
	},
	# Misterio — diálogos e interrogatorios. Drone grave, notas altas dispersas y frías.
	"misterio": {
		"chords": [[A1, E2, A2], [AS1, F2, AS2], [CS2, GS2, CS3]],
		"chord_dur": 9.0, "pad_gain": 0.070, "bass_gain": 0.13, "detune": 0.006,
		"trem_rate": 0.11, "trem_depth": 0.22,
		"motif": [GS4, AS4, B4, CS5, D5, DS5], "motif_gain": 0.075,
		"motif_rate": 5.6, "motif_decay": 2.6, "motif_random": true, "air_gain": 0.034,
	},
	# Tensión — confrontaciones. Racimo disonante, sub más marcado, motivo ascendente.
	"tension": {
		"chords": [[E2, G2, A2], [F2, GS2, AS2], [FS2, A2, B2]],
		"chord_dur": 4.5, "pad_gain": 0.078, "bass_gain": 0.15, "detune": 0.008,
		"trem_rate": 0.9, "trem_depth": 0.18,
		"motif": [A4, B4, C5, D5, DS5, E5], "motif_gain": 0.070,
		"motif_rate": 2.4, "motif_decay": 1.0, "motif_random": true, "air_gain": 0.030,
	},
	# Revelación — clímax y desenlace. Grave, resolutivo pero sombrío.
	"revelacion": {
		"chords": [[C2, G2, DS3], [GS2, C3, DS3], [F2, C3, GS3], [G2, B2, D3]],
		"chord_dur": 8.0, "pad_gain": 0.090, "bass_gain": 0.14, "detune": 0.005,
		"trem_rate": 0.14, "trem_depth": 0.26,
		"motif": [DS4, F4, GS4, C5, DS5], "motif_gain": 0.080,
		"motif_rate": 4.2, "motif_decay": 2.2, "motif_random": false, "air_gain": 0.026,
	},
}

var _player: AudioStreamPlayer
var _active := false
var _t := 0.0                 # tiempo absoluto del sintetizador (s)
var _air_lp := 0.0            # estado del filtro paso-bajo del aire

var _mood_name := ""
var _p := {}                  # parámetros del mood actual (referencia a MOODS[x])
var _pending := ""            # mood al que se está cruzando ("" = ninguno)
var _fade := 1.6              # duración del cruce (s)

var _gain := 0.0             # ganancia de mezcla suavizada (0..1) para el duck del cruce
var _target := 0.0           # objetivo de _gain
var _vol := 1.0              # music_volume aplicado (0..1)

# Motivo/melodía: notas "pluck" activas y planificador.
var _notes: Array = []       # [{t0, freq, amp}]
var _next_note := 0.0
var _step := 0               # índice para el modo melódico (no aleatorio)


func _ready() -> void:
	randomize()
	_player = AudioStreamPlayer.new()
	var gen := AudioStreamGenerator.new()
	gen.mix_rate = MIX
	gen.buffer_length = 0.3
	_player.stream = gen
	_player.volume_db = -3.0
	add_child(_player)
	_player.play()
	set_process(false)   # inactivo hasta que una escena pida un mood


# ---------------------------------------------------------------------------
#  API pública
# ---------------------------------------------------------------------------
## Reproduce (o cruza a) un ambiente. `fade` = segundos del cruce suave.
func play_mood(name: String, fade: float = 1.6) -> void:
	if not MOODS.has(name):
		push_warning("Music: mood desconocido '%s'" % name)
		return
	_fade = maxf(fade, 0.05)
	if not _active:
		# Arranque en frío: fija el mood y sube desde silencio.
		_apply_mood(name)
		_active = true
		_target = 1.0
		set_process(true)
		return
	if name == _mood_name and _pending == "":
		return   # ya sonando
	# Cruce por "duck": bajar, cambiar en silencio, subir.
	_pending = name
	_target = 0.0


## Silencia la música con un fundido (deja el motor listo para el próximo mood).
func stop(fade: float = 1.2) -> void:
	if not _active:
		return
	_fade = maxf(fade, 0.05)
	_pending = ""
	_target = 0.0
	_mood_name = "__stopping__"


func current_mood() -> String:
	return _mood_name


func _apply_mood(name: String) -> void:
	_mood_name = name
	_p = MOODS[name]
	_next_note = _t + randf_range(0.3, float(_p.motif_rate))
	_step = 0


# ---------------------------------------------------------------------------
#  BUCLE DE AUDIO
# ---------------------------------------------------------------------------
func _process(delta: float) -> void:
	# Volumen del bus de música según el ajuste del jugador (da sentido al slider).
	var mv := clampf(float(Global.settings.get("music_volume", 0.8)), 0.0, 1.0)
	if not is_equal_approx(mv, _vol):
		_vol = mv
		_player.volume_db = linear_to_db(maxf(_vol, 0.0001)) - 3.0

	# Suaviza la ganancia de mezcla hacia su objetivo (duck del cruce).
	var rate := delta / _fade
	if _gain < _target:
		_gain = minf(_gain + rate, _target)
	elif _gain > _target:
		_gain = maxf(_gain - rate, _target)

	# En el fondo del duck: aplica el mood pendiente y vuelve a subir.
	if _gain <= 0.001:
		if _pending != "":
			_apply_mood(_pending)
			_pending = ""
			_target = 1.0
		elif _mood_name == "__stopping__":
			_active = false
			set_process(false)
			return

	var pb := _player.get_stream_playback()
	if pb == null:
		return
	# Poda notas del motivo ya extinguidas.
	var max_age := float(_p.get("motif_decay", 1.5)) * 4.0
	if not _notes.is_empty():
		_notes = _notes.filter(func(n): return _t - n.t0 < max_age)
	# Planifica nuevas notas del motivo (fuera del bucle por-muestra, más barato).
	while _t >= _next_note:
		_trigger_note()

	for i in pb.get_frames_available():
		var s := _sample()
		pb.push_frame(Vector2(s, s))


func _trigger_note() -> void:
	var scale: Array = _p.motif
	var freq: float
	if bool(_p.get("motif_random", true)):
		freq = float(scale[randi() % scale.size()])
	else:
		freq = float(scale[_step % scale.size()])
		_step += 1
	_notes.append({"t0": _t, "freq": freq, "amp": randf_range(0.7, 1.0)})
	var r := float(_p.motif_rate)
	_next_note = _t + r * randf_range(0.6, 1.5)


## Una muestra de audio (mono). Suma pad + sub-bajo + motivo + aire.
func _sample() -> float:
	_t += 1.0 / MIX
	var s := 0.0

	# --- Pad armónico con progresión de acordes y crossfade sin clic ---
	var chords: Array = _p.chords
	var n := chords.size()
	var cd := float(_p.chord_dur)
	var cp := _t / cd
	var i0 := int(floor(cp)) % n
	var frac: float = cp - floor(cp)
	var xf := 0.22
	var det := float(_p.detune)
	var pad := _chord_voice(chords[i0], det)
	if frac > 1.0 - xf:
		var k: float = (frac - (1.0 - xf)) / xf     # 0..1
		var i1 := (i0 + 1) % n
		pad = pad * (1.0 - k) + _chord_voice(chords[i1], det) * k
	var trem := (1.0 - float(_p.trem_depth)) + float(_p.trem_depth) * sin(_t * float(_p.trem_rate) * TAU * 0.5 + 1.0)
	s += pad * float(_p.pad_gain) * trem

	# --- Sub-bajo (raíz del acorde, una octava por debajo) con el mismo crossfade ---
	var root0 := float(chords[i0][0]) * 0.5
	var bass := sin(TAU * root0 * _t)
	if frac > 1.0 - xf:
		var k2: float = (frac - (1.0 - xf)) / xf
		var root1 := float(chords[(i0 + 1) % n][0]) * 0.5
		bass = bass * (1.0 - k2) + sin(TAU * root1 * _t) * k2
	s += bass * float(_p.bass_gain)

	# --- Motivo/melodía: "plucks" tipo campana con caída exponencial ---
	var mg := float(_p.motif_gain)
	var dec := float(_p.motif_decay)
	for note in _notes:
		var age: float = _t - note.t0
		if age < 0.0:
			continue
		var env: float = exp(-age / dec)
		var v: float = sin(TAU * note.freq * age)
		v += 0.5 * sin(TAU * note.freq * 2.0 * age) * exp(-age / (dec * 0.5))  # brillo/campana
		if age < 0.006:   # ataque suave (sin chasquido)
			v *= age / 0.006
		s += v * env * mg * float(note.amp)

	# --- Aire: ruido muy filtrado, casi subliminal (textura/tensión) ---
	var white := randf() * 2.0 - 1.0
	_air_lp = _air_lp * 0.85 + white * 0.15
	s += _air_lp * float(_p.get("air_gain", 0.0))

	return clampf(s * _gain, -1.0, 1.0)


## Voz de un acorde: cada nota, dos osciladores ligeramente desafinados (chorus cálido)
## más un armónico suave. Normalizado por el número de notas.
func _chord_voice(freqs: Array, detune: float) -> float:
	var v := 0.0
	for f in freqs:
		var ff := float(f)
		v += sin(TAU * ff * _t)
		v += 0.6 * sin(TAU * ff * (1.0 + detune) * _t)
		v += 0.25 * sin(TAU * ff * 2.0 * _t)   # brillo (2º armónico)
	return v / float(freqs.size())
