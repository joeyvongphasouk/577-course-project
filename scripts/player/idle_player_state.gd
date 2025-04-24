class_name IdlePlayerState

extends PlayerState
@onready var raider_player_model: PlayerModel = $"../../RaiderPlayerModel"

func enter():
	#print("idle state entered")
	raider_player_model.play_animation("i")

func update(delta):
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	if input_dir.length() != 0:
		#print("yee start walking")
		transition.emit("WalkingPlayerState")
