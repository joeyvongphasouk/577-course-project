extends CanvasLayer

@onready var audio_container: GridContainer = $MarginContainer/Panel/MarginContainer/VBoxContainer/AudioContainer
@onready var graphics_container: GridContainer = $MarginContainer/Panel/MarginContainer/VBoxContainer/GraphicsContainer
@onready var gameplay_container: Container = $MarginContainer/Panel/MarginContainer/VBoxContainer/GameplayContainer

@onready var audio_button: Button = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/AudioButton
@onready var graphics_button: Button = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/GraphicsButton
@onready var gameplay_button: Button = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/GameplayButton
@onready var exit_button: Button = $MarginContainer/Panel/MarginContainer/VBoxContainer/ExitButton

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export_group("Menu Sound Effects")
@export var sfx_hover: AudioStream
@export var sfx_click: AudioStream

signal exit_options_menu

# helpers
func hide_all_con() -> void:
	audio_container.hide()
	graphics_container.hide()
	gameplay_container.hide()

func play_sound(sfx: AudioStream) -> void:
	audio_stream_player.set_stream(sfx)
	audio_stream_player.play()

func _on_button_entered() -> void:
	play_sound(sfx_hover)

func _ready() -> void:
	set_process(false)
	audio_stream_player.set_bus("SFX")
	exit_button.connect("focus_entered", _on_button_entered)
	audio_button.connect("focus_entered", _on_button_entered)
	graphics_button.connect("focus_entered", _on_button_entered)
	gameplay_button.connect("focus_entered", _on_button_entered)

func start() -> void:
	audio_button.grab_focus()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		_on_exit_button_pressed()

# button signal presses
func _on_exit_button_pressed() -> void:
	play_sound(sfx_click)
	exit_options_menu.emit()
	set_process(false)

func _on_audio_button_pressed() -> void:
	play_sound(sfx_click)
	hide_all_con()
	audio_container.show()

func _on_graphics_button_pressed() -> void:
	play_sound(sfx_click)
	hide_all_con()
	graphics_container.show()

func _on_gameplay_button_pressed() -> void:
	play_sound(sfx_click)
	hide_all_con()
	gameplay_container.show()
	
func _on_audio_button_mouse_entered() -> void:
	audio_button.grab_focus()

func _on_graphics_button_mouse_entered() -> void:
	graphics_button.grab_focus()

func _on_gameplay_button_mouse_entered() -> void:
	gameplay_button.grab_focus()

func _on_exit_button_mouse_entered() -> void:
	exit_button.grab_focus()
