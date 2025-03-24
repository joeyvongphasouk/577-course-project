extends trigger
@onready var area_3d: Area3D = $StaticBody3D/Area3D

signal plate_pressed
signal plate_exited

@export var link_int: int

func _on_area_3d_body_entered(body: Node3D) -> void:
	print("body entered,", body)
	if !open:
		print("opeeeen")
		open = true
		_turn_on()

func _on_area_3d_body_exited(body: Node3D) -> void:
	print("body exited,", body)
	if area_3d.get_overlapping_areas().size() == 0:
		print("no mo")
		open = false
		_turn_off()
