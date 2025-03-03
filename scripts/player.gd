extends CharacterBody3D

#const SPEED = 5.0
#const JUMP_VELOCITY = 4.5
@onready var head: Node3D = $Head
@onready var grapple: Node3D = $Grapple


@export_group("Player Physics")
@export var mass: float = 1.0
@export var acceleration: float = 40.0
@export var deceleration: float = 10.0
#@export var gravity: float = 1.0
@export var jump_force: float = 5
@export var push_force: float = 2.0
# desired speed player can go
# note that this isnt max speed player can go
# but the speed that the player will lerp to
@export var rel_max_speed: float = 6

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

	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# orig way of going about it is to approach max speed in dir by linear interp
	# instead accel when there is an input, have less accel in the air
	if input_dir.length() != 0:
		
		# this is the movement in the air, can a person move in the air
		var move_acceleration = acceleration
		var move_speed = rel_max_speed
		if is_on_floor():
			velocity.x = lerpf(velocity.x, direction.x * move_speed, move_acceleration * delta)
			velocity.z = lerpf(velocity.z, direction.z * move_speed, move_acceleration * delta)
		
		# if we are in the air, accel to rel_max_speed, but make move_accel way worse
		else:
			move_acceleration *= 0.005
			velocity.x = lerpf(velocity.x, direction.x * move_speed, move_acceleration * delta)
			velocity.z = lerpf(velocity.z, direction.z * move_speed, move_acceleration * delta)
			
			
		
	# instead slow down by friction if player is on a surface
	elif is_on_floor():
		velocity.x = lerpf(velocity.x, 0, deceleration * delta)
		velocity.z = lerpf(velocity.z, 0, deceleration * delta)

	move_and_slide()
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
			
