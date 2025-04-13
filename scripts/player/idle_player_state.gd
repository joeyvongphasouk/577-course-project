class_name IdlePlayerState

extends PlayerState

func update(delta):
	if GlobalPlayer.player.velocity.length() > 0.0:
		print("yee start walking")
		transition.emit("WalkingPlayerState")
