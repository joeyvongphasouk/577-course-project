class_name WalkingPlayerState

extends PlayerState

func update(delta):
	if GlobalPlayer.player.velocity.length() == 0.0:
		print("yeeeeee stop walk")
		transition.emit("IdlePlayerState")
