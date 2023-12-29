extends Node

var _hitbox_lod = 5

func _load_json(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()

	var json = JSON.new()
	var error = json.parse(content)

	if error == OK:
		var data_received = json.data
		return data_received


func _create_cutout(cutout_info, texture_root):
	# Create node
	var cutout = get_node("CutoutManager/CutoutPrefab").duplicate()
	var sprite = cutout.get_node("Sprite")
	var texture = load(texture_root + cutout_info['texture'])
		
	# Add texture
	cutout.name = cutout_info['texture'].split('.')[0]
	sprite.texture = texture
	sprite.material = sprite.material.duplicate()
	
	# Set collision polygon from texture
	var data = texture.get_image()
	
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(data)
	
	var polys = bitmap.opaque_to_polygons(
		Rect2(
			Vector2.ZERO,
			texture.get_size()
		),
		_hitbox_lod
	)
	
	var collision_polygon = cutout.get_node("CollisionPolygon2D")
	collision_polygon.polygon = polys[0]

	if sprite.centered:
		collision_polygon.position -= Vector2(bitmap.get_size())/2
	
	# If children components in cutout_info, call _create_cutout on them
	if 'children' in cutout_info:
		for child_info in cutout_info['children']:
			var child_cutout = _create_cutout(child_info, texture_root)
			cutout.add_child(child_cutout)

	return cutout

func _create_level(level_info, texture_root):
	var background_image = load(texture_root + level_info["background"])
	get_node("Background").texture = background_image
	
	var max_side = max(background_image.get_width(), background_image.get_width())
	var puzzle_scale = 512.0 / max_side
	
	self.scale = Vector2(puzzle_scale, puzzle_scale)
	
	for cutout_info in level_info["cutouts"]:
		var cutout = _create_cutout(cutout_info, texture_root)
		get_node("CutoutManager").add_child(cutout)
	
	get_node("CutoutManager/CutoutPrefab").queue_free()


func _ready():
	var level_info = _load_json("res://Levels/level0.json")
	_create_level(level_info, "res://Textures/Levels/level0/")


func _process(delta):
	pass
