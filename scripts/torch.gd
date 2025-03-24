extends Node3D
@onready var fire_node: Node3D = $fire_node

@export var initial_lit: bool = true

func _ready() -> void:
	fire_node.visible = initial_lit

func _trigger_off():
	fire_node.hide()

func _trigger_on():
	fire_node.show()
	fire_node.restart_particles()
