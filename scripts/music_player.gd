extends AudioStreamPlayer

var fade_in: bool = true

enum music_state {PLAYING, FADE_IN, FADE_OUT, STOP}
#var bus_index = AudioServer.get_bus_index("Music")

func _ready() -> void:
	stream = load("res://assets/audio/music/1. Ancient Echoes Loop.wav")
	set_bus("Music")
	play()

func _process(delta: float) -> void:
	#if fading:
		#volume_db
	pass
