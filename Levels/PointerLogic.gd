extends Area2D

# Load the custom images for the mouse cursor.
var dot
var hand_open
var hand_closed

# Variables for dragging
var dragging = false

var drag_offset = Vector2()
var over_shape = false

func _ready():	
	set_process_input(true)

func _process(delta):
	if dragging:
		position = get_global_mouse_position() - drag_offset
	else:
		drag_offset = get_global_mouse_position() - position

func _on_mouse_shape_exited(shape_idx):
	over_shape = false

func _on_mouse_shape_entered(shape_idx):
	over_shape = true
