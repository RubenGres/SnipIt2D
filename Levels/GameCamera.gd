extends Camera2D

var _camera_moving
var _camera_offset

func _ready():
	pass

func _process(delta):
	if _camera_moving:
		self.position += _camera_offset - get_global_mouse_position()
	else:
		_camera_offset = get_global_mouse_position()
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				_camera_moving = true
			else:
				_camera_moving = false
