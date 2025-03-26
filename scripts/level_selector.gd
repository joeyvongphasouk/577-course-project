extends CanvasLayer

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var l_1_button: TextureButton = $MarginContainer/HBoxContainer/level_one/l1_button
@onready var l_2_button: TextureButton = $MarginContainer/HBoxContainer/level_two/l2_button
@onready var l_3_button: TextureButton = $MarginContainer/HBoxContainer/level_three/l3_button
@onready var l_4_button: TextureButton = $MarginContainer/HBoxContainer/level_four/l4_button
@onready var p_button: TextureButton = $MarginContainer/HBoxContainer/playground/p_button

@export_group("Menu Sound Effects")
@export var sfx_hover: AudioStream
@export var sfx_click: AudioStream

func play_sound(sfx: AudioStream) -> void:
	audio_stream_player.set_stream(sfx)
	audio_stream_player.play()

func _on_button_entered() -> void:
	play_sound(sfx_hover)

func _ready() -> void:
	pass
	#l_1_button.connect("pressed", _scene_button)
	#l_2_button.connect("pressed", _scene_button)
	#l_3_button.connect("pressed", _scene_button)
	#l_4_button.connect("pressed", _scene_button)
	#p_button.connect("pressed", _scene_button)
	#exit_button.connect("focus_entered", _on_button_entered)
	#audio_button.connect("focus_entered", _on_button_entered)
	#graphics_button.connect("focus_entered", _on_button_entered)
	#gameplay_button.connect("focus_entered", _on_button_entered)



# button receivers
func _on_l_1_button_pressed() -> void:
	play_sound(sfx_click)
	button_to_scene("res://scenes/levels/tutorial.tscn")
	pass # Replace with function body.

func _on_l_2_button_pressed() -> void:
	pass # Replace with function body.

func _on_l_3_button_pressed() -> void:
	pass # Replace with function body.

func _on_l_4_button_pressed() -> void:
	pass # Replace with function body.

func _on_p_button_pressed() -> void:
	play_sound(sfx_click)
	button_to_scene("res://scenes/levels/playground.tscn")
	pass # Replace with function body.

func button_to_scene(scene : String) -> void:
	get_tree().change_scene_to_file(scene)
