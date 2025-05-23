extends CanvasLayer
@onready var start_button: Button = $MenuPanel/MarginContainer/VBoxContainer/VBoxContainer2/Start
@onready var options_button: Button = $MenuPanel/MarginContainer/VBoxContainer/VBoxContainer2/Options
@onready var quit_button: Button = $MenuPanel/MarginContainer/VBoxContainer/VBoxContainer2/Quit
@onready var menu_panel: Control = $MenuPanel
@onready var options_menu: CanvasLayer = $options_menu
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var level_selector: CanvasLayer = $level_selector

@export_group("Menu Sound Effects")
@export var sfx_hover: AudioStream
@export var sfx_click: AudioStream
#@export var sfx_slide: AudioStream

func _ready() -> void:
	start_button.grab_focus()
	start_button.connect("focus_entered", _on_button_entered)
	options_button.connect("focus_entered", _on_button_entered)
	quit_button.connect("focus_entered", _on_button_entered)
	audio_stream_player.set_bus("SFX")
	options_menu.exit_options_menu.connect(on_exit_options)
	level_selector.exit_level_selector_menu.connect(on_exit_level_select)
	
# signals for pressing a button
func _on_start_pressed() -> void:
	play_sound(sfx_click)
	menu_panel.visible = false
	level_selector.visible = true
	level_selector.set_process(true)
	
	
	# get_tree().change_scene_to_file(current_level_path)

func _on_options_pressed() -> void:
	play_sound(sfx_click)
	menu_panel.visible = false
	options_menu.visible = true
	options_menu.set_process(true)
	options_menu.audio_button.grab_focus()
	
func _on_quit_pressed() -> void:
	play_sound(sfx_click)
	get_tree().quit()

func on_exit_options() -> void:
	menu_panel.visible = true
	options_menu.visible = false
	options_button.grab_focus()

func on_exit_level_select() -> void:
	menu_panel.visible = true
	level_selector.visible = false
	start_button.grab_focus()

# signals for getting focus and hover
func _on_start_mouse_entered() -> void:
	start_button.grab_focus()
func _on_options_mouse_entered() -> void:
	options_button.grab_focus()
func _on_quit_mouse_entered() -> void:
	quit_button.grab_focus()
	
func _on_button_entered() -> void:
	play_sound(sfx_hover)
func play_sound(sfx: AudioStream) -> void:
	audio_stream_player.set_stream(sfx)
	audio_stream_player.play()
