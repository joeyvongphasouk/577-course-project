extends RigidBody3D
@onready var key_model: Node3D = $KeyModel
var current_highlight = false

signal key_pickup_signal

func highlight(highlight : bool):
	if current_highlight != highlight:
		current_highlight = highlight
		key_model.highlight_mesh(highlight)
	
func pickup():
	key_pickup_signal.emit()
	self.queue_free()
