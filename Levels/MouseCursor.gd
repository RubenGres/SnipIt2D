extends Node

# Load the custom images for the mouse cursor.
var dot = load("res://Textures/gui/dot.png")
var hand = load("res://Textures/gui/hand_open.png")

func _ready():
	# Set the default cursor
	Input.set_custom_mouse_cursor(dot)

func _mouse_entered():
	# Change the cursor when the mouse enters the object
	Input.set_custom_mouse_cursor(hand)

func _mouse_exited():
	# Revert to the default cursor when the mouse leaves the object
	Input.set_custom_mouse_cursor(dot)


func _on_area_2d_mouse_shape_entered(shape_idx):
	pass # Replace with function body.

