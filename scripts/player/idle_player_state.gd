class_name IdlePlayerState

extends PlayerState
@onready var raider_player_model: PlayerModel = $"../../RaiderPlayerModel"
var current_anim: String = "wf"

func enter():
	#print("idle state entered")
	raider_player_model.play_animation("i")

func update(delta):
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	if input_dir.length() != 0:
		if GlobalPlayer.player.is_crouching:
			transition.emit("CrouchingMovePlayerState")
		else:
			transition.emit("WalkingPlayerState")
	
	if GlobalPlayer.player.is_crouching and current_anim != "ci":
		current_anim = "ci"
		raider_player_model.play_animation(current_anim)
	elif !GlobalPlayer.player.is_crouching and current_anim != "i":
		current_anim = "i"
		raider_player_model.play_animation(current_anim)
	
		#print("yee start walking")
		transition.emit("WalkingPlayerState")
