class_name WalkingPlayerState

extends PlayerState
@onready var raider_player_model: PlayerModel = $"../../RaiderPlayerModel"
var current_anim: String = "wf"

func enter():
	raider_player_model.play_animation(current_anim)
	
func update(delta):
	if GlobalPlayer.player.is_crouching:
		transition.emit("IdlePlayerState")
		return
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	if input_dir.length() == 0:
		#print("enter idle")
		transition.emit("IdlePlayerState")
		return
	
	var new_anim = ""
	var w: bool = Input.is_action_pressed("move_forward")
	var a: bool = Input.is_action_pressed("move_left")
	var s: bool = Input.is_action_pressed("move_back")
	var d: bool = Input.is_action_pressed("move_right")
	if w:
		if a:
			new_anim = "wfl"
		elif s:
			new_anim = "wfr"
		else:
			new_anim = "wf"
	elif s:
		if a:
			new_anim = "wbl"
		elif s:
			new_anim = "wbr"
		else:
			new_anim = "wb"
	elif a:
		new_anim = "wl"
	elif d:
		new_anim = "wr"
	
	if current_anim == new_anim:
		return
		
	current_anim = new_anim
	raider_player_model.play_animation(current_anim)
