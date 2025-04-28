extends Node3D
@onready var door_2: Node3D = $DoorBody/Door2
var current_highlight = false
var open = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func highlight(highlight : bool):
	if current_highlight != highlight and !open:
		current_highlight = highlight
		door_2.highlight_mesh(highlight)
	
func open_door() -> bool:
	if open:
		animation_player.play("DoorOpen")
		open = true
		return true
	else:
		return false
