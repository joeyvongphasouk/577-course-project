extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var options_menu: CanvasLayer = $options_menu
@onready var panel_container: PanelContainer = $PanelContainer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@onready var resume_button: Button = $PanelContainer/VBoxContainer2/Resume
@onready var options_button: Button = $PanelContainer/VBoxContainer2/Options
@onready var main_menu_button: Button = $PanelContainer/VBoxContainer2/MainMenu

@export_group("Menu Sound Effects")
@export var sfx_hover: AudioStream
@export var sfx_click: AudioStream

func play_sound(sfx: AudioStream) -> void:
	audio_stream_player.set_stream(sfx)
	audio_stream_player.play()

func _ready() -> void:
	resume_button.connect("focus_entered", _on_button_entered)
	options_button.connect("focus_entered", _on_button_entered)
	main_menu_button.connect("focus_entered", _on_button_entered)
	options_menu.exit_options_menu.connect(on_exit_options_menu)
	get_tree().paused = false
	set_process_unhandled_input(true)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if options_menu.visible:
			on_exit_options_menu()
		else:
			SetPaused(!get_tree().paused)
	
func SetPaused(paused: bool) -> void:
	
	get_tree().paused = paused
	
	if (paused):
		resume_button.grab_focus()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		animation_player.play("blur")
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		animation_player.play_backwards("blur")
		resume_button.release_focus()
		release_focus()
		get_viewport().set_input_as_handled()

func _on_resume_pressed() -> void:
	play_sound(sfx_click)
	SetPaused(false)

func _on_options_pressed() -> void:
	play_sound(sfx_click)
	panel_container.visible = false
	options_menu.visible = true
	options_menu.set_process(true)
	options_menu.audio_button.grab_focus()

func _on_main_menu_pressed() -> void:
	play_sound(sfx_click)
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func on_exit_options_menu() -> void:
	panel_container.visible = true
	options_menu.visible = false

func _on_button_entered() -> void:
	play_sound(sfx_hover)

func _on_resume_mouse_entered() -> void:
	resume_button.grab_focus()

func _on_options_mouse_entered() -> void:
	options_button.grab_focus()

func _on_main_menu_mouse_entered() -> void:
	main_menu_button.grab_focus()
