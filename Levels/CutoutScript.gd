extends Area2D

# Variables for dragging
var dragging = false
var over_shape = false
var is_snipped = false

var _drag_offset = Vector2()


func snip():
	is_snipped = true

func _ready():	
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
