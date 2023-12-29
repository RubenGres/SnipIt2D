extends Node



func _ready():
	set_process_input(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				%CutoutManager.pickup_cutout()
			else:
				%CutoutManager.snip_or_drop_cutout()
					
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				%GameCamera.grab()
			else:
				%GameCamera.drop()
				
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			%GameCamera.zoom_in()
			
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			%GameCamera.zoom_out()
