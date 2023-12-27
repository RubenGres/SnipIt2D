extends Node2D

var dragging = false
var over_shape = false

var dot = load("res://Textures/gui/dot.png")
var hand_open = load("res://Textures/gui/hand_open.png")
var hand_closed = load("res://Textures/gui/hand_closed.png")

var children

func _ready():
	children =  get_children()
	children.reverse()
	Input.set_custom_mouse_cursor(dot)
	set_process_input(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				for child in children:
					if child.over_shape:
						child.dragging = true
						break
			else:
				for child in children:
					child.dragging = false
	
func _process(delta):
	over_shape = false
	dragging = false
	for child in children:
		over_shape = over_shape or child.over_shape
		dragging = dragging or child.dragging
	
	if over_shape:
		if dragging:
			Input.set_custom_mouse_cursor(hand_closed)
		else:
			Input.set_custom_mouse_cursor(hand_open)
	else:
		Input.set_custom_mouse_cursor(dot)
