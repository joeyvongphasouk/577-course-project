extends Node3D

@export var next_level_path: String

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		print("going to next level...")
		get_tree().change_scene_to_file(next_level_path)
