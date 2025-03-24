extends trigger
@onready var fire_area: Area3D = $fire_area
@onready var fire_node: Node3D = $fire_node

@export var lit: bool = true

func _ready():
	fire_area.add_to_group("fire_source")
	if !lit:
		fire_node.hide()
		open = false

func light():
	fire_node.show()
	open = true
	_turn_on()
	
