extends Node
## Sonda de runtime del motor de música (carga el proyecto completo -> autoloads OK).
## Uso: godot --headless --path . res://tools/TestMusicProbe.tscn

var _frames := 0
var _moods := ["noir", "investigacion", "misterio", "tension", "revelacion"]
var _mi := 0

func _ready() -> void:
	Music.play_mood(_moods[0], 0.1)

func _process(_delta: float) -> void:
	_frames += 1
	if _frames % 20 == 0 and _mi < _moods.size() - 1:
		_mi += 1
		Music.play_mood(_moods[_mi], 0.1)   # ejercita los cruces entre moods
	if _frames >= 140:
		var pb = Music._player.get_stream_playback()
		print("PROBE: t=%.2fs gain=%.2f mood=%s notas=%d playback=%s"
			% [Music._t, Music._gain, Music.current_mood(), Music._notes.size(), str(pb != null)])
		print("PROBE RESULTADO: " + ("AUDIO GENERANDO" if Music._t > 0.01 else "sin frames (driver dummy)"))
		get_tree().quit(0)
