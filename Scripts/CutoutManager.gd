class_name CutoutManager
extends Node2D

var _min_pitch = 0.7
var _max_pitch = 3

var _dragged_cutout

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

func pickup_cutout():
	var index = _get_top_cutout_index()
	
	if index != -1:
		var cutout = _childrens[index]
		if cutout.is_snipped:
			_put_cutout_on_top(index)
			cutout.pickup()
			_dragged_cutout = cutout

func snip_or_drop_cutout():
	if _dragged_cutout:
		_drop_cutout()
	else:
		_snip_cutout()

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

func _set_pitch_in_cutouts():
	var areas = []
	for child in _childrens:
		areas.append(child.get_area())
		
	var min_area = areas.min()
	var max_area = areas.max()
	
	for child in _childrens:
		child.pitch = _min_pitch +  (_max_pitch - _min_pitch) * 1-(child.area/max_area)

func _reorder_cutouts():
	for child_index in range(len(_childrens)):
		var child = _childrens[child_index]
		child.z_index = child_index + 1

func _ready():
	_reorder_cutouts()

func _process(delta):
	_set_pitch_in_cutouts()	
	_childrens = get_children()
	
	var index = _get_top_cutout_index()
	if index != -1:
		var cutout = _childrens[index]
		
		if not cutout.is_snipped:
			%MouseCursor.change_cursor("cissors_open")
		elif not cutout.dragging:
			%MouseCursor.change_cursor("hand_open")
		else:
			%MouseCursor.change_cursor("hand_closed")
	else:
		%MouseCursor.change_cursor("dot")
		
