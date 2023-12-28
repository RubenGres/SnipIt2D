extends Node

func _load_json(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()

	var json = JSON.new()
	var error = json.parse(content)

	if error == OK:
		var data_received = json.data
		if typeof(data_received) == TYPE_ARRAY:
			return data_received

func _create_level(level_info, texture_root):
	pass

func _ready():
	var level_info = _load_json("res://Levels/level0.json")
	_create_level(level_info, "res://Textures/Levels/level0/")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
