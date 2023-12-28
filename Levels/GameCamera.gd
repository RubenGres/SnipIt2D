extends Camera2D

var _camera_moving
var _camera_offset

var _zooming_step = 0.05
var _min_zoom = 0.5
var _max_zoom = 3

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
				
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			var scale_factor = 1 + _zooming_step
			var new_scale = clamp(self.zoom[0] * scale_factor, _min_zoom, _max_zoom)
			self.zoom = Vector2(new_scale, new_scale)
			
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			var scale_factor = 1 - _zooming_step
			var new_scale = clamp(self.zoom[0] * scale_factor, _min_zoom, _max_zoom)
			self.zoom = Vector2(new_scale, new_scale)
