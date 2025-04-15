extends Node3D

@export var trap_trigger: Node
@export var arrow_speed: int = 8
@onready var arrow_scene = preload("res://scenes/environment/traps/arrow.tscn")
var arrow_scene_temp

func _ready() -> void:
	if trap_trigger:
		trap_trigger.trap_triggered.connect(_spawn_arrow)

func _spawn_arrow() -> void:
	print("spawning arrow")
	if arrow_scene_temp:
		arrow_scene_temp.queue_free()
		
	arrow_scene_temp = arrow_scene.instantiate()
	
	# note, arrow shoots in the x dir of the arrowtrap
	arrow_scene_temp.direction = Vector3(1, 0, 0)
	arrow_scene_temp.speed = arrow_speed
	add_child(arrow_scene_temp)
