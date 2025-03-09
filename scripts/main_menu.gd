extends CanvasLayer
@onready var start: Button = $MenuPanel/VBoxContainer/Start
@onready var menu_panel: Control = $MenuPanel
@onready var options_menu: CanvasLayer = $options_menu

func _ready() -> void:
	start.grab_focus()
	options_menu.exit_options_menu.connect(on_exit_options_menu)

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/playground.tscn")

func _on_options_pressed() -> void:
	menu_panel.visible = false
	options_menu.visible = true
	options_menu.set_process(true)
	
func _on_quit_pressed() -> void:
	get_tree().quit()

func on_exit_options_menu() -> void:
	menu_panel.visible = true
	options_menu.visible = false
