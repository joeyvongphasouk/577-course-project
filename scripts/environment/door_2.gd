extends Node3D
@export var outline_material: Material
@onready var door: MeshInstance3D = $Door

func highlight_mesh(highlight : bool):
	if highlight:
		door.material_overlay = outline_material
	else:
		door.material_overlay = null
