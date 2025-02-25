extends CharacterBody3D

#const SPEED = 5.0
#const JUMP_VELOCITY = 4.5
@onready var head: Node3D = $Head
@onready var grapple: Node3D = $Grapple


@export_group("Player Physics")
@export var mass: float = 1.0
@export var acceleration: float = 15.0
@export var deceleration: float = 17.0
#@export var gravity: float = 1.0
@export var jump_force: float = 5
@export var speed: float = 5.0

@export_group("Movement Controls")
@export var sensitivity: float = 0.002

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event) -> void:
	# Look around
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensitivity)
		head.rotation.x = head.rotation.x - event.relative.y * sensitivity
		
		# dont want to spin all the way
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or grapple.launched):
		velocity.y += jump_force
		
		# should we have it so that grapple retracts when we jump?
		#grapple.retract() 

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if input_dir.length() != 0:
		velocity.x = lerpf(velocity.x, direction.x * speed, acceleration * delta)
		velocity.z = lerpf(velocity.z, direction.z * speed, acceleration * delta)
	else:
		velocity.x = lerpf(velocity.x, 0, deceleration * delta)
		velocity.z = lerpf(velocity.z, 0, deceleration * delta)

	move_and_slide()
