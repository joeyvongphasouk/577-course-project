extends RayCast3D
@onready var crosshair: ColorRect = $"../Camera3D/Crosshair"

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func _process(_delta: float) -> void:
	if is_colliding():
		crosshair.set_color(Color(0.5, 1.0, 0.5, 0.7))
	else:
		crosshair.set_color(Color(1.0, 1.0, 1.0, 0.7))
	#var mousePos=get_viewport().get_mouse_position()
	#$Ray.target_position.x = mousePos.x
	#$Ray.target_position.y = mousePos.y
#
	#print($Ray.target_position) # watch the output to see this
#
	#if $Ray.is_colliding(): print("Hit ", $Ray.get_collider())
