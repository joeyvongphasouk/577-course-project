extends CanvasLayer

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var l_1_button: TextureButton = $MarginContainer/VBoxContainer/HBoxContainer/level_one/l1_button
@onready var l_2_button: TextureButton = $MarginContainer/VBoxContainer/HBoxContainer/level_two/l2_button
@onready var l_3_button: TextureButton = $MarginContainer/VBoxContainer/HBoxContainer/level_three/l3_button
@onready var l_4_button: TextureButton = $MarginContainer/VBoxContainer/HBoxContainer/level_four/l4_button
@onready var p_button: TextureButton = $MarginContainer/VBoxContainer/HBoxContainer/playground/p_button
@onready var main_menu_button: Button = $MarginContainer/VBoxContainer/MainMenuButton

@export_group("Menu Sound Effects")
@export var sfx_hover: AudioStream
@export var sfx_click: AudioStream

signal exit_level_selector_menu

@onready var levels: Dictionary = {"l_1": l_1_button,
								"l_2": l_2_button,
								"l_3": l_3_button,
								"l_4": l_4_button,
								"p": p_button,
									}

var locked_levels = ["l_2", "l_3", "l_4"]

func play_sound(sfx: AudioStream) -> void:
	audio_stream_player.set_stream(sfx)
	audio_stream_player.play()

func _on_button_entered() -> void:
	play_sound(sfx_hover)

func _ready() -> void:
	l_1_button.grab_focus()
	l_1_button.connect("focus_entered", _on_button_entered)
	l_2_button.connect("focus_entered", _on_button_entered)
	l_3_button.connect("focus_entered", _on_button_entered)
	l_4_button.connect("focus_entered", _on_button_entered)
	p_button.connect("focus_entered", _on_button_entered)
	l_1_button.connect("focus_entered", _on_button_entered)
	main_menu_button.connect("focus_entered", _on_button_entered)
	
	# initially make all textures grayed out
	for key in levels:
		var level: TextureButton = levels[key]
		level.modulate = Color(0.2, 0.2, 0.2, 1.0)
		
	#l_1_button.connect("pressed", _scene_button)
	#l_2_button.connect("pressed", _scene_button)
	#l_3_button.connect("pressed", _scene_button)
	#l_4_button.connect("pressed", _scene_button)
	#p_button.connect("pressed", _scene_button)
	#exit_button.connect("focus_entered", _on_button_entered)
	#audio_button.connect("focus_entered", _on_button_entered)
	#graphics_button.connect("focus_entered", _on_button_entered)
	#gameplay_button.connect("focus_entered", _on_button_entered)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		_on_main_menu_button_pressed()

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


func _on_main_menu_button_pressed() -> void:
	play_sound(sfx_click)
	exit_level_selector_menu.emit()
	set_process(false)



func _on_l_1_button_mouse_entered() -> void:
	l_1_button.grab_focus()
	showcase("l_1")
func _on_l_2_button_mouse_entered() -> void:
	l_2_button.grab_focus()
	showcase("l_2")
func _on_l_3_button_mouse_entered() -> void:
	l_3_button.grab_focus()
	showcase("l_3")
func _on_l_4_button_mouse_entered() -> void:
	l_4_button.grab_focus()
	showcase("l_4")
func _on_p_button_mouse_entered() -> void:
	p_button.grab_focus()
	showcase("p")
func _on_main_menu_button_mouse_entered() -> void:
	main_menu_button.grab_focus()

func showcase(button: String) -> void:
	if button not in locked_levels:
		var level: TextureButton = levels[button]
		level.modulate = Color(1.0, 1.0, 1.0, 1.0)


func _on_l_1_button_mouse_exited() -> void:
	levels["l_1"].modulate = Color(0.2, 0.2, 0.2, 1.0)

func _on_l_2_button_mouse_exited() -> void:
	levels["l_2"].modulate = Color(0.2, 0.2, 0.2, 1.0)

func _on_l_3_button_mouse_exited() -> void:
	levels["l_3"].modulate = Color(0.2, 0.2, 0.2, 1.0)

func _on_l_4_button_mouse_exited() -> void:
	levels["l_4"].modulate = Color(0.2, 0.2, 0.2, 1.0)

func _on_p_button_mouse_exited() -> void:
	levels["p"].modulate = Color(0.2, 0.2, 0.2, 1.0)
