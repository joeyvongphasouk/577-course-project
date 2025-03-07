extends CanvasLayer
@onready var start: Button = $VBoxContainer/Start

func _ready() -> void:
	start.grab_focus()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/playground.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
