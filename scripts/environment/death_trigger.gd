extends Node3D

#signal respawn_signal

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		print("respawning player...")
		GlobalPlayer.player._respawn()
		#emit_signal("respawn_signal")
