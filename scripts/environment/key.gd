extends RigidBody3D
@onready var key_model: Node3D = $KeyModel
var current_highlight = false

func highlight(highlight : bool):
	if current_highlight != highlight:
		current_highlight = highlight
		#print("highlight", highlight)
		key_model.highlight_mesh(highlight)
	
func pickup():
	print("yep pickup receive")
	pass
