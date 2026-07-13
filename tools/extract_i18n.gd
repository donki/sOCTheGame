extends Node
func _ready() -> void:
	var strings := {}
	var add := func(s):
		if s is String and String(s).strip_edges() != "":
			strings[s] = true
	for pass_done in [false, true]:
		Global.reset_case()
		for ch in range(1, 21):
			Global.chapter = ch
			add.call(Story.chapter_title())
			for loc in Story.locations():
				add.call(loc.get("name", ""))
				add.call(loc.get("sub", ""))
				if pass_done:
					Global.set_flag("done_" + String(loc.id), true)
				var dlg: Dictionary = Story.get_dialogue(String(loc.id))
				_collect(dlg, add)
	var arr: Array = strings.keys()
	var f := FileAccess.open("res://assets/i18n/_es_strings.json", FileAccess.WRITE)
	f.store_string(JSON.stringify(arr))
	f.close()
	print("EXTRACT: ", arr.size(), " cadenas")
	get_tree().quit(0)

func _collect(dlg: Dictionary, add: Callable) -> void:
	if dlg.has("clue"):
		add.call(dlg.clue.get("title", "")); add.call(dlg.clue.get("text", ""))
	if dlg.has("clues"):
		for c in dlg.clues:
			add.call(c.get("title", "")); add.call(c.get("text", ""))
	for b in dlg.get("beats", []):
		_collect_beat(b, add)

func _collect_beat(b: Dictionary, add: Callable) -> void:
	if b.has("text"):
		add.call(b.text)
	if b.has("choices"):
		for ch in b.choices:
			add.call(ch.get("text", ""))
			for tb in ch.get("then", []):
				_collect_beat(tb, add)
