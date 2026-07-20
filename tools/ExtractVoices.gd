extends Node
# Recorre todos los capitulos y vuelca las lineas habladas (who,text) a un JSON.
func _ready() -> void:
	Global.tool_mode = true   # no persistir: este recorrido NO es una partida
	var out: Array = []
	var seen: Dictionary = {}
	for ch in Story.CHAPTERS.keys():
		Global.chapter = int(ch)
		for loc in Story.locations():
			var d: Dictionary = Story.get_dialogue(String(loc.id))
			_collect(d.get("beats", []), out, seen)
		for id in Story.INTERACT.keys():
			var it: Dictionary = Story.INTERACT[id]
			if String(it.get("type", "")) == "present":
				var sp: String = String(it.get("speaker", ""))
				for st in it.get("statements", []):
					_add(sp, String((st as Dictionary).get("text", "")), out, seen)
	var f := FileAccess.open("user://voice_lines.json", FileAccess.WRITE)
	f.store_string(JSON.stringify(out))
	f.close()
	print("VOICE_LINES=", out.size(), " -> ", ProjectSettings.globalize_path("user://voice_lines.json"))
	get_tree().quit(0)

func _collect(beats: Array, out: Array, seen: Dictionary) -> void:
	for beat in beats:
		var b: Dictionary = beat
		if b.has("choices"):
			for c in b.choices:
				_add("detective", String((c as Dictionary).get("text", "")), out, seen)
				_collect((c as Dictionary).get("then", []), out, seen)
		elif b.has("text"):
			_add(String(b.get("who", "narrador")), String(b.get("text", "")), out, seen)

func _add(who: String, text: String, out: Array, seen: Dictionary) -> void:
	if who == "" or who == "narrador":
		return
	var t: String = text.strip_edges()
	if t == "":
		return
	var key: String = who + "|" + t
	if seen.has(key):
		return
	seen[key] = true
	out.append({"who": who, "text": t})
