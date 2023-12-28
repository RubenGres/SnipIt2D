extends Node

func play(sound, pitch=1.0):
	var audio_stream_play = get_node(sound)
	audio_stream_play.pitch_scale = pitch
	audio_stream_play.play()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
