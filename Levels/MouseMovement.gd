class_name InteractiveObjects
extends Node2D

var _zooming_step = 0.05
var _camera_moving = false
var _camera_offset = Vector2(0, 0)

var _dragged_cutout

var _mouse_scale
var _cursor_icons = {
	"dot": load("res://Textures/gui/cursors/dot.png"),
	"hand_open": load("res://Textures/gui/cursors/hand_open.png"),
	"hand_closed": load("res://Textures/gui/cursors/hand_closed.png"),
	"cissors_open": load("res://Textures/gui/cursors/cissors_open.png")
}

var _childrens: Array

func _get_top_cutout_index():
	for i in range(_childrens.size() - 1, -1, -1):
		var child = _childrens[i]
		if child.over_shape:
			return i

	return -1

func _put_cutout_on_top(index):
	var cutout = _childrens[index]
	_childrens.remove_at(index)
	_childrens.append(cutout)
	_reorder_cutouts()

func _pickup_cutout():
	var index = _get_top_cutout_index()
	
	if index != -1:
		var cutout = _childrens[index]
		if cutout.is_snipped:
			_put_cutout_on_top(index)
			cutout.pickup()
			_dragged_cutout = cutout

func _drop_cutout():
	if _dragged_cutout:
		_dragged_cutout.drop()
		_dragged_cutout = null

func _snip_cutout():
	var index = _get_top_cutout_index()
	if index != -1:
		var cutout = _childrens[index]
		if not cutout.is_snipped:
			cutout.snip()

func _set_pitch_in_cutout():
	var areas = []
	for child in _childrens:
		areas.append(child.get_area())
		
	var min_area = areas.min()
	var max_area = areas.max()
	
	for child in _childrens:
		child.pitch = 1 - (child.area / max_area) + 0.5

func _reorder_cutouts():
	for child_index in range(len(_childrens)):
		var child = _childrens[child_index]
		child.z_index = child_index + 1

func _ready():
	set_process_input(true)
	
	_childrens = get_children()
	_set_pitch_in_cutout()	
	_reorder_cutouts()
	
	_mouse_scale = %MouseCursor.scale
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
	
	var index = _get_top_cutout_index()
	if index != -1:
		var cutout = _childrens[index]
		
		if not cutout.is_snipped:
			current_cursor = _cursor_icons["cissors_open"]
		elif not cutout.dragging:
			current_cursor = _cursor_icons["hand_open"]
		else:
			current_cursor = _cursor_icons["hand_closed"]
	
	%MouseCursor.texture = current_cursor
	%MouseCursor.scale = _mouse_scale * 1/%GameCamera.zoom
	%MouseCursor.position = get_global_mouse_position()
