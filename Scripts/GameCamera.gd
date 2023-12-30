extends Camera2D


var zooming_step = 0.05
var min_zoom = 0.5
var max_zoom = 3
var max_speed = 3000
var acceleration_factor = 1000
var stop_treshold = 1000
var friction = 0.95

var _acceleration = Vector2.ZERO
var _velocity = Vector2.ZERO
var _camera_moving = false
var _camera_offset = Vector2.ZERO

func zoom_in():
	var scale_factor = 1 + zooming_step
	var new_scale = clamp(self.zoom[0] * scale_factor, min_zoom, max_zoom)
	self.zoom = Vector2(new_scale, new_scale)


func zoom_out():
	var scale_factor = 1 - zooming_step
	var new_scale = clamp(self.zoom[0] * scale_factor, min_zoom, max_zoom)
	self.zoom = Vector2(new_scale, new_scale)


func grab():
	_camera_offset = get_global_mouse_position()
	_camera_moving = true

func drop():
	_camera_moving = false


func _ready():
	pass


func _process(delta):
	var mouse_position_change = get_global_mouse_position() - _camera_offset
	if _camera_moving:
		self.position += _camera_offset - get_global_mouse_position()		
		_acceleration = mouse_position_change * acceleration_factor
	else:
		_acceleration *= Vector2(friction, friction)
		_velocity = _acceleration * delta
		_velocity = _velocity.limit_length(max_speed)
		
		if _acceleration.length() < stop_treshold:
			_acceleration = Vector2.ZERO

		self.global_transform.origin -= Vector2(_velocity.x, _velocity.y) * delta
