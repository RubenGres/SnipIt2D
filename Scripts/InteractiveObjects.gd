extends Area2D

# Parameters
var pitch = 1
var outline_width = 2

# Variables for dragging
var dragging = false
var over_shape = false
var is_snipped = false

var sprite
var area


var _drag_offset = Vector2()
var _hover_count = 0

var _SFX_ref

func _get_polygon_area(polygon):
	var area = 0.0
	var n = polygon.size()
	for i in range(n):
		var j = (i + 1) % n
		area += polygon[i].x * polygon[j].y
		area -= polygon[j].x * polygon[i].y
	return abs(area) / 2.0

func snip():
	sprite.material.set_shader_parameter("width", outline_width)
	_SFX_ref.play("cut")
	is_snipped = true
	
func pickup():
	_SFX_ref.play("pickup", pitch)
	dragging = true
	
func drop():
	_SFX_ref.play("drop", pitch)
	dragging = false

func get_area():
	var collision_polygon = $CollisionPolygon2D
	area = _get_polygon_area(collision_polygon.polygon)
	return area

func _ready():
	sprite = get_node("Sprite")
	sprite.material.set_shader_parameter("width", 0)
	_SFX_ref = get_tree().get_root().get_node("LevelScene/SFX")
	
	set_process_input(true)

func _process(delta):
	var puzzle = get_tree().get_root().get_node("LevelScene/Puzzle")

	if dragging:
		position = get_global_mouse_position() / puzzle.scale - _drag_offset
	else:
		_drag_offset = get_global_mouse_position() / puzzle.scale - position 

func _on_mouse_shape_entered(shape_idx):
	_hover_count += 1
	if _hover_count == 1:
		over_shape = true

func _on_mouse_shape_exited(shape_idx):
	_hover_count -= 1
	if _hover_count == 0:
		over_shape = false
