# https://www.youtube.com/watch?v=NY5ZkBSGpEA resolution
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

# resolution vars
@onready var resolution_drop_button: OptionButton = $MarginContainer/Panel/MarginContainer/VBoxContainer/GraphicsContainer/ResolutionDropButton
@onready var fullscreen_checkbox: CheckBox = $MarginContainer/Panel/MarginContainer/VBoxContainer/GraphicsContainer/FullscreenCheckbox

var Resolutions: Dictionary = {"3840x2160":Vector2i(3840,2160),
								"2560x1440":Vector2i(2560,1080),
								"1920x1080":Vector2i(1920,1080),
								"1366x768":Vector2i(1366,768),
								"1536x864":Vector2i(1536,864),
								"1280x720":Vector2i(1280,720),
								"1440x900":Vector2i(1440,900),
								"1600x900":Vector2i(1600,900),
								"1024x600":Vector2i(1024,600),
								"800x600": Vector2i(800,600)}

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

	# options default stuffs
	add_resolution()
	check_variables()
	

func start() -> void:
	audio_button.grab_focus()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		_on_exit_button_pressed()




# resolution functions
func add_resolution() -> void:
	var current_resolution = get_window().get_size()
	var ID = 0
	
	for r in Resolutions:
		resolution_drop_button.add_item(r, ID)
		if Resolutions[r] == current_resolution:
			resolution_drop_button.select(ID)
		
		ID += 1

func set_resolution_text():
	var resolution_text = str(get_window().get_size().x)+"x"+str(get_window().get_size().y)
	resolution_drop_button.set_text(resolution_text)
	
	#scale_slider.set_value_no_signal(100.00)
	#_on_scale_slider_value_changed(100.00)


func check_variables() -> void:
	var _window = get_window()
	var mode = _window.get_mode()
	
	if mode == Window.MODE_FULLSCREEN:
		fullscreen_checkbox.set_pressed_no_signal(true)
		resolution_drop_button.set_disabled(true)
		print("yeppers")

func center_window() -> void:
	var center_screen = DisplayServer.screen_get_position()+DisplayServer.screen_get_size()/2
	var window_size = get_window().get_size_with_decorations()
	get_window().set_position(center_screen-window_size/2)

func _on_fullscreen_checkbox_toggled(toggled_on: bool) -> void:
	resolution_drop_button.set_disabled(toggled_on)
	if toggled_on:
		get_window().set_mode(Window.MODE_FULLSCREEN)
	else:
		get_window().set_mode(Window.MODE_WINDOWED)
	get_tree().create_timer(.05).timeout.connect(set_resolution_text)

func _on_resolution_drop_button_item_selected(index: int) -> void:
	var ID = resolution_drop_button.get_item_text(index)
	get_window().set_size(Resolutions[ID])
	center_window()




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
