class_name CursorLogic
extends Node2D

var _zooming_step = 0.05
var _camera_moving = false
var _camera_offset = Vector2(0, 0)

var _mouse_scale

var _dragged_cutout

var _cursor_icons = {
	"dot": load("res://Textures/gui/cursors/dot.png"),
	"hand_open": load("res://Textures/gui/cursors/hand_open.png"),
	"hand_closed": load("res://Textures/gui/cursors/hand_closed.png"),
	"cissors_open": load("res://Textures/gui/cursors/cissors_open.png")
}

var _children

func _get_top_cutout():
	for child in _children:
		if child.over_shape:
			return child
			
	return null

func _pickup_cutout():
	var cutout = _get_top_cutout()
	
	if cutout:
		if cutout.is_snipped:
			cutout.pickup()
			_dragged_cutout = cutout

func _drop_cutout():
	if _dragged_cutout:
		_dragged_cutout.drop()
		_dragged_cutout = null

func _snip_cutout():
	var cutout = _get_top_cutout()
	if cutout:
		if not cutout.is_snipped:
			cutout.snip()

func _ready():
	_children = get_children()
	_children.reverse()
	
	_mouse_scale = %MouseCursor.scale
	
	set_process_input(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				_pickup_cutout()
			else:
				if _dragged_cutout:
					_drop_cutout()
				else:
					_snip_cutout()
					
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				_camera_moving = true
			else:
				_camera_moving = false
		
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			var scale_factor = 1 + _zooming_step
			var new_scale = clamp(%GameCamera.zoom[0] * scale_factor, 1, 3)
			%GameCamera.zoom = Vector2(new_scale, new_scale)
			
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			var scale_factor = 1 - _zooming_step
			var new_scale = clamp(%GameCamera.zoom[0] * scale_factor, 1, 3)
			%GameCamera.zoom = Vector2(new_scale, new_scale)
	
func _process(delta):
	var current_cursor = _cursor_icons["dot"]
	
	var cutout = _get_top_cutout()
	if cutout:
		if not cutout.is_snipped:
			current_cursor = _cursor_icons["cissors_open"]
		elif not cutout.dragging:
			current_cursor = _cursor_icons["hand_open"]
		else:
			current_cursor = _cursor_icons["hand_closed"]
	%MouseCursor.texture = current_cursor
	
	if _camera_moving:
		%GameCamera.position += _camera_offset - get_local_mouse_position()
	else:
		_camera_offset = get_local_mouse_position()
	
	%MouseCursor.scale = _mouse_scale * 1/%GameCamera.zoom
	%MouseCursor.position = get_global_mouse_position()
