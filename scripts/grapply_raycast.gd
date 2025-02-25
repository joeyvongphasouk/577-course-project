extends RayCast3D

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func _physics_process(delta: float) -> void:
	pass
	#if is_colliding():
		#var hit = get_collider()
		#print(hit.name)
	#var mousePos=get_viewport().get_mouse_position()
	#$Ray.target_position.x = mousePos.x
	#$Ray.target_position.y = mousePos.y
#
	#print($Ray.target_position) # watch the output to see this
#
	#if $Ray.is_colliding(): print("Hit ", $Ray.get_collider())
