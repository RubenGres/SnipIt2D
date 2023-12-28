extends Node

func play(sound):
	var audio_stream_play = get_node(sound)
	#TODO randomize pitch
	audio_stream_play.pitch_scale = randf_range(1, 3)
	audio_stream_play.play()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
