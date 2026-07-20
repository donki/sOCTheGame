extends Node
## Vuelca las pistas REALES de cada capítulo (las falsas no se atan en el tablero),
## en el orden en que las suelta la historia, para poder autorar las parejas de
## Story.CHX_LINKS sabiendo con qué se cuenta.
## Ejecutar:  godot --headless res://tools/DumpChapterClues.tscn

func _ready() -> void:
	Global.tool_mode = true   # este recorrido NO es una partida
	var out: Dictionary = {}
	for ch in Story.CHAPTERS.keys():
		Global.chapter = int(ch)
		var reales: Array = []
		var falsas := 0
		for loc in Story.locations():
			var d: Dictionary = Story.get_dialogue(String(loc.id))
			for c in _clues_of(d):
				if bool(c.get("false", false)):
					falsas += 1
				else:
					reales.append({"loc": String(loc.id), "title": String(c.get("title", "")),
						"text": String(c.get("text", ""))})
		# Las mini-escenas (búsqueda/examinar/…) también sueltan pistas.
		for loc in Story.locations():
			var idata: Dictionary = Story.interact_data(String(loc.id))
			for c in _clues_of(idata):
				if not bool(c.get("false", false)):
					var t := String(c.get("title", ""))
					if not _has(reales, t):
						reales.append({"loc": String(loc.id) + "*", "title": t,
							"text": String(c.get("text", ""))})
		out[str(ch)] = {"title": Story.chapter_title(), "reales": reales, "falsas": falsas,
			"end_flag": Story.end_flag(), "complete_flag": Story.complete_flag()}
		print("\n--- Cap %d · %s   (%d reales, %d falsas)" % [ch, Story.chapter_title(), reales.size(), falsas])
		for c in reales:
			print("    [%s] %s  ::  %s" % [c["loc"], c["title"], c["text"]])
	var f := FileAccess.open("user://chapter_clues.json", FileAccess.WRITE)
	f.store_string(JSON.stringify(out, "  "))
	f.close()
	print("\n-> ", ProjectSettings.globalize_path("user://chapter_clues.json"))
	get_tree().quit(0)


func _clues_of(d: Dictionary) -> Array:
	var r: Array = []
	if typeof(d.get("clue")) == TYPE_DICTIONARY:
		r.append(d["clue"])
	for c in d.get("clues", []):
		if typeof(c) == TYPE_DICTIONARY:
			r.append(c)
	return r


func _has(arr: Array, title: String) -> bool:
	for a in arr:
		if String(a["title"]) == title:
			return true
	return false
