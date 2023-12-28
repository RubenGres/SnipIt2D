extends Area2D

# Variables for dragging
var dragging = false
var over_shape = false
var is_snipped = false

var texture

var _drag_offset = Vector2()


func snip():
	texture.material.set_shader_parameter("width", 3)
	%SFX.play("cut")
	is_snipped = true
	
func pickup():
	%SFX.play("pickup")
	dragging = true
	
func drop():
	%SFX.play("drop")
	dragging = false

func _ready():
	#var shader = Shader.new()
	#self.material = shader_material
	#shader.set_code(load("res://Levels/Outline.gdshader").get_as_text())
	#texture.material.set_shader(shader)
	texture = get_node("Texture")
	texture.material.set_shader_parameter("color", Color(1.0, 1.0, 1.0, 1.0))
	texture.material.set_shader_parameter("width", 0)
	texture.material.set_shader_parameter("pattern", 1)
	set_process_input(true)

func _process(delta):
	if dragging:
		position = get_global_mouse_position() / %Puzzle.scale - _drag_offset
	else:
		_drag_offset = get_global_mouse_position() / %Puzzle.scale - position 

func _on_mouse_shape_exited(shape_idx):
	over_shape = false

func _on_mouse_shape_entered(shape_idx):
	over_shape = true
