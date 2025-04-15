extends Node3D

var speed = 8
@onready var direction

func _physics_process(delta: float) -> void:
	position += speed * delta * direction

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		print("yowch")
		self.queue_free()
