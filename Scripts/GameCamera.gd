extends Camera2D

var _camera_moving
var _camera_offset

var _zooming_step = 0.05
var _min_zoom = 0.5
var _max_zoom = 3

func zoom_in():
	var scale_factor = 1 + _zooming_step
	var new_scale = clamp(self.zoom[0] * scale_factor, _min_zoom, _max_zoom)
	self.zoom = Vector2(new_scale, new_scale)


func zoom_out():
	var scale_factor = 1 - _zooming_step
	var new_scale = clamp(self.zoom[0] * scale_factor, _min_zoom, _max_zoom)
	self.zoom = Vector2(new_scale, new_scale)


func grab():
	_camera_moving = true


func drop():
	_camera_moving = false


func _ready():
	pass


func _process(delta):
	if _camera_moving:
		self.position += _camera_offset - get_global_mouse_position()
	else:
		_camera_offset = get_global_mouse_position()
