extends CanvasLayer

# refers to the player
@export var player: PackedScene

func update_health() -> void:
	player.current_health / player.max_health * 100
	pass
