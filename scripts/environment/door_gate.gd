extends Node3D

## These are the conditions that the door needs in order to open
@export var open_conditions: Array[trigger]
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var door_open: bool = false

func _ready() -> void:
	for cond in open_conditions:
		cond.connect("trigger_change", Callable(self, "_on_trigger_change"))

func _on_trigger_change():
	var trigger_open = true
	for cond in open_conditions:
		if !cond.open:
			trigger_open = false
			break
	print("trigger check: ", trigger_open, door_open)
	
	if trigger_open and !door_open:
		door_open = true
		animation_player.play("DoorOpen")
	elif !trigger_open and door_open:
		door_open = false
		animation_player.play_backwards("DoorOpen")
		
