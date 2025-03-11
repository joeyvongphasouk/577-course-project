extends CanvasLayer
@onready var exit_button: Button = $MarginContainer/Panel/MarginContainer/VBoxContainer/ExitButton

signal exit_options_menu

func _ready() -> void:
	set_process(false)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		_on_exit_button_pressed()

func _on_exit_button_pressed() -> void:
	print("hyelllllo")
	exit_options_menu.emit()
	set_process(false)
