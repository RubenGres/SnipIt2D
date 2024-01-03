extends Area2D

# Parameters
var pitch = 1
var _outline_width
@export var pickup_height = 10
@export var dependencies_paths:Array[NodePath] = []

# Variables for dragging
var dragging = false
var is_snipped = false
var dependencies:Array[Node] = []

var sprite
var shadow
var area

var _over_shape = false
var _drag_offset = Vector2()
var _hover_count = 0

var _SFX_ref
var _puzzle_ref
var _camera_ref

func _get_polygon_area(polygon):
	var area = 0.0
	var n = polygon.size()
	for i in range(n):
		var j = (i + 1) % n
		area += polygon[i].x * polygon[j].y
		area -= polygon[j].x * polygon[i].y
	return abs(area) / 2.0

func is_snippable():
	if not _over_shape:
		return false

	var can_be_snipped = true
	for dep in dependencies:
		if not dep.is_snipped:
			return false

	return true

func snip():
	if(is_snippable):
		_SFX_ref.play("cut")
		sprite.material.set_shader_parameter("opacity", 0)
		is_snipped = true
	
func pickup():
	if is_snipped and not dragging:
		_SFX_ref.play("pickup", pitch)
		shadow.material.set_shader_parameter("opacity", 1)
		_drag_offset = get_global_mouse_position() / _puzzle_ref.scale - position
		_drag_offset += Vector2(-pickup_height, pickup_height)
		dragging = true
	
func drop():
	if dragging:
		_SFX_ref.play("drop", pitch)
		shadow.material.set_shader_parameter("opacity", 0)
		position += Vector2(-pickup_height, pickup_height)
		dragging = false

func get_area():
	var collision_polygon = $CollisionPolygon2D
	area = _get_polygon_area(collision_polygon.polygon)
	return area

func _ready():
	_SFX_ref = $"../../../Player/SFX"
	sprite = get_node("Sprite")
	shadow = get_node("Sprite_shadow")
	sprite.material.set_shader_parameter("opacity", 0)
	_outline_width = sprite.material.get_shader_parameter("line_thickness")
	
	# create dependencies list from paths
	if len(dependencies_paths) != 0:
		var new_deps:Array[Node] = []
		for path in dependencies_paths:
			new_deps.append(get_node(path))
		dependencies = new_deps
	
	set_process_input(true)

func _process(delta):
	_puzzle_ref = $"../../"
	_camera_ref = $"../../../Player/GameCamera"
	
	if is_snipped:
		sprite.material.set_shader_parameter("opacity", 1)
		sprite.material.set_shader_parameter("line_thickness", _outline_width / sqrt(_camera_ref.zoom[0]))

	if dragging:
		position = get_global_mouse_position() / _puzzle_ref.scale - _drag_offset		

func _on_mouse_shape_entered(shape_idx):
	_hover_count += 1
	if _hover_count == 1:
		_over_shape = true

func _on_mouse_shape_exited(shape_idx):
	_hover_count -= 1
	if _hover_count == 0:
		_over_shape = false
