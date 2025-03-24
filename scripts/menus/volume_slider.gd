extends HSlider

@export var bus_name: String
var bus_index: int

@export var sfx_hover: AudioStream
@export var audio_player: AudioStreamPlayer

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)
	audio_player.set_bus("SFX")
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	
func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	audio_player.play()
	
