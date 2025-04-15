class_name CrouchingMovePlayerState

extends PlayerState
@onready var raider_player_model: PlayerModel = $"../../RaiderPlayerModel"
var current_anim: String = "cf"

func enter():
	raider_player_model.play_animation(current_anim)
	
func update(delta):
	if !GlobalPlayer.player.is_crouching:
		transition.emit("WalkingPlayerState")
		return
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	if input_dir.length() == 0:
		transition.emit("IdlePlayerState")
		return
	
	var new_anim = ""
	var w: bool = Input.is_action_pressed("move_forward")
	var a: bool = Input.is_action_pressed("move_left")
	var s: bool = Input.is_action_pressed("move_back")
	var d: bool = Input.is_action_pressed("move_right")
	if w:
		if a:
			new_anim = "cfl"
		elif s:
			new_anim = "cfr"
		else:
			new_anim = "cf"
	elif s:
		if a:
			new_anim = "cbl"
		elif s:
			new_anim = "cbr"
		else:
			new_anim = "cb"
	elif a:
		new_anim = "cl"
	elif d:
		new_anim = "cr"
	
	if current_anim == new_anim:
		return
		
	current_anim = new_anim
	raider_player_model.play_animation(current_anim)
