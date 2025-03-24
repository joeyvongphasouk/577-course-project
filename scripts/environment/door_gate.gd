extends Node3D

## These are the conditions that the door needs in order to open
@export var open_conditions: Array[trigger]
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var door_open: bool = false

func _ready() -> void:
	for cond in open_conditions:
		cond.connect("trigger_change", Callable(self, "_on_trigger_change"))

func _on_trigger_change():
	print("trigger check")
	var trigger_open = true
	for cond in open_conditions:
		if !cond.open:
			trigger_open = false
			break
	
	if trigger_open and !door_open:
		animation_player.play("Open")
	elif !trigger_open and door_open:
		animation_player.play("Close")
		
