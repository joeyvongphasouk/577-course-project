extends Control

var menus: bool = true

func _ready() -> void:
	set_process_unhandled_input(true)
	hide()

func _unhandled_input(event: InputEvent) -> void:
	if !menus and event.is_action_pressed("pause"):
		SetPaused(!get_tree().paused)
	
func SetPaused(paused: bool) -> void:
	if menus:
		return
	
	get_tree().paused = paused
	
	if (paused):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		show()
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		hide()


func _on_resume_pressed() -> void:
	if !menus:
		SetPaused(!get_tree().paused)


func _on_main_menu_pressed() -> void:
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	menus = true
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
