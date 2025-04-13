extends Node3D

signal trap_triggered

func _on_area_3d_body_entered(body: Node3D) -> void:
	print("hello?")
	if body is Player:
		print("shooting arrow")
		emit_signal("trap_triggered")
