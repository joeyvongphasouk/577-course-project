extends Node3D
@onready var key_mesh: MeshInstance3D = $Sketchfab_model/Key_obj_cleaner_materialmerger_gles/Object_2
@export var outline_material: Material

func highlight_mesh(highlight : bool):
	if highlight:
		key_mesh.material_overlay = outline_material
	else:
		key_mesh.material_overlay = null
