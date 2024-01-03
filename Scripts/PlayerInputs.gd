extends Node

var mouseVelocity = Vector2.ZERO
var _cutout_manager

func _ready():
	set_process_input(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	_cutout_manager = $"../Puzzle/CutoutManager"

func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				_cutout_manager.pickup_cutout()
			else:
				_cutout_manager.snip_or_drop_cutout()
					
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				$GameCamera.grab()
			else:
				$GameCamera.drop()
				
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			$GameCamera.zoom_in()
			
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			$GameCamera.zoom_out()
			
	if event is InputEventMouseMotion:
		mouseVelocity += event.relative
