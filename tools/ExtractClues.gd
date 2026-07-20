extends Node
# Vuelca todas las pistas (title,text,false) del juego a un JSON, para generar
# las fotos de objeto (assets/objects/<slug-del-titulo>.png).
func _ready() -> void:
	Global.tool_mode = true   # no persistir: este recorrido NO es una partida
	var out: Array = []
	var seen: Dictionary = {}
	for ch in Story.CHAPTERS.keys():
		Global.chapter = int(ch)
		for loc in Story.locations():
			var d: Dictionary = Story.get_dialogue(String(loc.id))
			_add(d.get("clue", {}), out, seen)
			for c in d.get("clues", []):
				_add(c, out, seen)
	for id in Story.INTERACT.keys():
		_add((Story.INTERACT[id] as Dictionary).get("clue", {}), out, seen)
	var f := FileAccess.open("user://clues.json", FileAccess.WRITE)
	f.store_string(JSON.stringify(out))
	f.close()
	print("CLUES=", out.size(), " -> ", ProjectSettings.globalize_path("user://clues.json"))
	get_tree().quit(0)

func _add(c: Variant, out: Array, seen: Dictionary) -> void:
	if typeof(c) != TYPE_DICTIONARY:
		return
	var title: String = String((c as Dictionary).get("title", "")).strip_edges()
	if title == "" or seen.has(title):
		return
	seen[title] = true
	out.append({
		"title": title,
		"text": String((c as Dictionary).get("text", "")),
		"false": bool((c as Dictionary).get("false", false)),
		"slug": Global.clue_slug(title),
	})
