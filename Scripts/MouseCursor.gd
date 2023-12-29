extends Sprite2D

var _cursor_scale

var _cursor_icons = {
	"dot": load("res://Textures/gui/cursors/dot.png"),
	"hand_open": load("res://Textures/gui/cursors/hand_open.png"),
	"hand_closed": load("res://Textures/gui/cursors/hand_closed.png"),
	"cissors_open": load("res://Textures/gui/cursors/cissors_open.png")
}

func change_cursor(type):
	self.texture = _cursor_icons[type]


func _ready():
	_cursor_scale = self.scale


func _process(delta):
	self.scale = _cursor_scale * 1/%GameCamera.zoom
	self.position = get_global_mouse_position()
