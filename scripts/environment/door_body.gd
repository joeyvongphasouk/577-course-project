extends StaticBody3D
@onready var door_2: Node3D = $Door2
var current_highlight = false
var open = false
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

func highlight(highlight : bool):
	if open:
		door_2.highlight_mesh(false)
	if current_highlight != highlight:
		current_highlight = highlight
		door_2.highlight_mesh(highlight)
	
func open_door() -> bool:
	if !open:
		animation_player.play("DoorOpen")
		open = true
		return true
	else:
		return false
