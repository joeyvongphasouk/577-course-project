extends Node3D
@onready var fire_node: Node3D = $fire_node

@export var initial_lit: bool = true

var lit: bool

func _ready() -> void:
	fire_node.visible = initial_lit
	lit = initial_lit

func _trigger_off():
	print("off", lit)
	lit = !lit
	print("off", lit)
	flip()

func _trigger_on():
	print("on", lit)
	lit = !lit
	print("on", lit)
	flip()
	
func flip():
	if lit:
		fire_node.show()
		fire_node.restart_particles()
	else:
		fire_node.hide()
