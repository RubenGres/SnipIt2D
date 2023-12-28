extends Area2D

# Variables for dragging
var dragging = false
var over_shape = false
var is_snipped = false

var texture
var area

var pitch = 1

var _drag_offset = Vector2()
var _hover_count = 0

func _get_polygon_area(polygon):
	var area = 0.0
	var n = polygon.size()
	for i in range(n):
		var j = (i + 1) % n
		area += polygon[i].x * polygon[j].y
		area -= polygon[j].x * polygon[i].y
	return abs(area) / 2.0

func snip():
	texture.material.set_shader_parameter("width", 3)
	%SFX.play("cut")
	is_snipped = true
	
func pickup():
	%SFX.play("pickup", pitch)
	dragging = true
	
func drop():
	%SFX.play("drop", pitch)
	dragging = false

func get_area():
	var collision_polygon = $CollisionPolygon2D
	area = _get_polygon_area(collision_polygon.polygon)
	return area

func _ready():
	texture = get_node("Texture")
	texture.material.set_shader_parameter("width", 0)
	
	set_process_input(true)

func _process(delta):
	if dragging:
		position = get_global_mouse_position() / %Puzzle.scale - _drag_offset
	else:
		_drag_offset = get_global_mouse_position() / %Puzzle.scale - position 

func _on_mouse_shape_entered(shape_idx):
	_hover_count += 1
	if _hover_count == 1:
		over_shape = true

func _on_mouse_shape_exited(shape_idx):
	_hover_count -= 1
	if _hover_count == 0:
		over_shape = false
