extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var resume: Button = $PanelContainer/VBoxContainer2/Resume
@onready var options_menu: CanvasLayer = $options_menu
@onready var panel_container: PanelContainer = $PanelContainer

func _ready() -> void:
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
		resume.grab_focus()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		animation_player.play("blur")
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		animation_player.play_backwards("blur")
		resume.release_focus()
		release_focus()
		get_viewport().set_input_as_handled()

func _on_resume_pressed() -> void:
	SetPaused(false)

func _on_options_pressed() -> void:
	panel_container.visible = false
	options_menu.visible = true
	options_menu.set_process(true)

func _on_main_menu_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func on_exit_options_menu() -> void:
	panel_container.visible = true
	options_menu.visible = false
