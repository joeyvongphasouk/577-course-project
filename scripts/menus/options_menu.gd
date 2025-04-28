# https://www.youtube.com/watch?v=NY5ZkBSGpEA resolution
extends CanvasLayer

@onready var audio_container: GridContainer = $MarginContainer/Panel/MarginContainer/VBoxContainer/AudioContainer
@onready var graphics_container: GridContainer = $MarginContainer/Panel/MarginContainer/VBoxContainer/GraphicsContainer
@onready var gameplay_container: ScrollContainer = $MarginContainer/Panel/MarginContainer/VBoxContainer/GameplayContainer
@onready var accept_node: Control = $AcceptNode

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

# input remapping
var is_remapping = false
var action_to_remap = null
var remapping_button = null

@onready var input_button_scene = preload("res://scenes/menus/input_button.tscn")
@onready var action_list: VBoxContainer = $MarginContainer/Panel/MarginContainer/VBoxContainer/GameplayContainer/ActionList

var input_actions = {
	"move_forward" : "Move Forwards",
	"move_back" : "Move Backwards",
	"move_left" : "Move Left",
	"move_right" : "Move Right",
	"jump" : "Jump",
	"grapple_attach" : "Shoot Grapple",
	"grapple_pull" : "Retract Grapple",
	"crouch" : "Crouch",
	"extinguish" : "Extinguish Fire"
}

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
	
	# add to the input key remapping def
	create_actions()

func create_actions():
	InputMap.load_from_project_settings()
	for item in action_list.get_children():
		item.queue_free()
	
	for action in input_actions:
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("LabelAction")
		var input_label = button.find_child("LabelInput")
		
		action_label.text = input_actions[action]
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
		
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))
		
func _on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("LabelInput").text = "Press key to bind..."

func _input(event):
	if is_remapping:
		if (event is InputEventKey || (event is InputEventMouseButton && event.pressed)):
			if event is InputEventMouseButton && event.double_click:
				event.double_click = false
			
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			_update_action_list(remapping_button, event)
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			
			accept_node.accept_event()

func _update_action_list(button, event):
	button.find_child("LabelInput").text = event.as_text().trim_suffix(" (Physical)")

func start() -> void:
	audio_button.grab_focus()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		_on_exit_button_pressed()


# input remapping actions
func _create_action_list():
	#InputMap.load_from_project_settings()
	#for item in remapping_container.get_children():
		#item.queue_free()
	#
	#for action in InputMap.get_actions()
	#var button = int
	pass

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
