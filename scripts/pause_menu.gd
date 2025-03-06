extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var resume: Button = $PanelContainer/VBoxContainer2/Resume

func _ready() -> void:
	get_tree().paused = false
	set_process_unhandled_input(true)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
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
	pass # Replace with function body.

func _on_main_menu_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
