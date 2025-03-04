extends Control


#func _ready() -> void:
	#pass # Replace with function body.
#
#func _process(delta: float) -> void:
	#pass

func _on_start_pressed() -> void:
	PauseManager.menus = false
	PauseManager.SetPaused(false)
	get_tree().change_scene_to_file("res://scenes/playground.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
