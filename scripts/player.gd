extends CharacterBody3D

@onready var head: Node3D = $Head
@onready var camera_3d: Camera3D = $Head/Camera3D
@onready var grapple_raycast: RayCast3D = $Head/GrappleRaycast
@onready var gun_tip: Node3D = $Head/Camera3D/WeaponRig/grapple_gun/GunTip
@onready var grapple_gun_anim: AnimationPlayer = $Head/Camera3D/WeaponRig/grapple_gun/AnimationPlayer

@export_group("Player Physics")
@export var player_mass: float = 80.0
@export var deceleration: float = 10.0
@export var jump_force: float = 5
@export var push_force: float = 2.0
# desired speed player can go
# note that this isnt max speed player can go
# but the speed that the player will lerp to
@export var rel_max_speed: float = 6
@export var rel_max_speed_crouch: float = 2.5
@export var rel_max_speed_sprint: float = 9
@export var rel_max_accel_air: float = 2.0
@export var rel_max_accel_ground: float =  40.0
var player_speed = rel_max_speed
var player_accel = rel_max_accel_ground

@export_group("Movement Controls")
@export var sensitivity: float = 0.002

@export_group("Head Bobbing")
@export var headbob_freq: float = 2.0
@export var headbob_amp: float = 0.04
var headbob_time: float = 0.0

# footstep sounds
@onready var footstep_audio_3d: AudioStreamPlayer3D = $FootstepAudio3D
var footstep_play: bool = true
var footstep_land: bool = false

@export_group("Grapple Variables")
@export var rope_scene: PackedScene
var launched: bool = false
var grapple_point: Vector3
var obj_hit: CollisionObject3D
var rope_dist: float
var verlet_rope: Node3D
var rope_2_script
var rope_2_node: Node3D
var rope_2_grapple_point_node: Node3D
var pullable_mass: float = 115

# crouching
var is_crouching: bool = false
var crouch_speed: float = 7.0
@export var TOGGLE_CROUCH: bool = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shape_cast_crouch: ShapeCast3D = $ShapeCastCrouch

# player stats
@export var max_health: float = 100
@onready var current_health: float = max_health
signal health_changed

func _ready() -> void:
	shape_cast_crouch.add_exception($".")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	rope_2_script = load("res://addons/verlet_rope_4/VerletRope.cs")
	
func _unhandled_input(event) -> void:
	# Look around
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensitivity)
		head.rotation.x = head.rotation.x - event.relative.y * sensitivity
		
		# dont want to spin all the way
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("crouch") and TOGGLE_CROUCH:
		toggle_crouch()
	if event.is_action_pressed("crouch") and !TOGGLE_CROUCH:
		crouching(true)
	if event.is_action_released("crouch") and !TOGGLE_CROUCH:
		if !shape_cast_crouch.is_colliding():
			crouching(false)
		else:
			crouch_check()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or launched):
		velocity.y += jump_force
		
		# should we have it so that grapple retracts when we jump?
		# retract() 

	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# orig way of going about it is to approach max speed in dir by linear interp
	# instead accel when there is an input, have less accel in the air
	if input_dir.length() != 0:
		
		# set move_speed and move_accel vars based on state of player
		if is_on_floor():
			set_accel("ground")
			
		else:
			set_accel("air")
		
		
		velocity.x = lerpf(velocity.x, direction.x * player_speed, player_accel * delta)
		velocity.z = lerpf(velocity.z, direction.z * player_speed, player_accel * delta)
		
	#
		#
		#print("curr:", velocity.x, " wanted:", direction.x * player_speed)
		#if velocity.x > direction.x * player_speed:
			#velocity.x = lerpf(velocity.x, direction.x * player_speed, player_accel * delta)
		#
		#if velocity.z > direction.z * player_speed:
			#velocity.z = lerpf(velocity.z, direction.z * player_speed, player_accel * delta)

	# instead slow down by friction if player is on a surface
	elif is_on_floor():
		velocity.x = lerpf(velocity.x, 0, deceleration * delta)
		velocity.z = lerpf(velocity.z, 0, deceleration * delta)

	


	#coll.
	#if velocity.length() > 10:
		## calc new health and emit health signal change to HUD
		#print("yep dmg")
		#emit_signal("health_changed")
	grapple_handle(delta)
	
	# make the ground "stickier"; micromovements off ground are removed
	if (is_on_floor() and velocity.y < 1.0):
		velocity.y = 0
	
	# actually apply movement to char
	# move_and_slide() modifies the vel of the player
	# if the player had collided with an object
	move_and_slide()
	
	# check for collision on objects
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			var push_dir = -c.get_normal()
			var velocity_diff_in_push_dir = self.velocity.dot(push_dir) - c.get_collider().linear_velocity.dot(push_dir)
			velocity_diff_in_push_dir = max(velocity_diff_in_push_dir, 0)
			var mass_ratio = min(1, player_mass / c.get_collider().mass) # person mass is 80 kg
			push_dir.y = 0
			var push_force = mass_ratio * 2.0
			
			# push relative to the global position of the collider
			c.get_collider().apply_impulse(push_dir * velocity_diff_in_push_dir * push_force, c.get_position() - c.get_collider().global_position)
		
		# also need to check for player collision on going too fast
		# get collision normal of the obj hit, and compare according to 
		#print(c.get_remainder().length())
		#if (c.get_remainder().length() > 0.15):
		if (c.get_remainder().length() > 0.05):
			print("col obj norm:", c.get_normal(), "| col rem vec:", c.get_remainder(), "| play vec:", velocity)
	
	
	
	# bobbing
	headbob_time += delta * velocity.length() * float (is_on_floor())
	camera_3d.transform.origin = headbob(headbob_time)
	
	if not footstep_land and is_on_floor():
		footstep_audio_3d.play()
	elif footstep_land and not is_on_floor():
		footstep_audio_3d.play()
	footstep_land = is_on_floor()
		

func headbob(headbob_time):
	var headbob_pos = Vector3.ZERO
	headbob_pos.y = sin(headbob_time * headbob_freq) * headbob_amp
	headbob_pos.x = cos(headbob_time * headbob_freq / 2) * headbob_amp
	
	var footstep_threshold = -headbob_amp + 0.002
	if headbob_pos.y > footstep_threshold:
		footstep_play = true
	elif headbob_pos.y < footstep_threshold and footstep_play:
		footstep_play = false
		footstep_audio_3d.play()
	
	return headbob_pos

# handle all vel changes here from the grapple
func grapple_handle(delta: float) -> void:
	# change states of grapple
	if Input.is_action_just_pressed("grapple_attach"):
		launch()
		
		# animate the rope
		if !grapple_gun_anim.is_playing():
			grapple_gun_anim.play("Shoot")
	if Input.is_action_just_released("grapple_attach"):
		retract()

		#pass
	if launched:
		handle_grapple(delta)

func launch():
	if grapple_raycast.is_colliding():
		grapple_point = grapple_raycast.get_collision_point()
		rope_dist = global_position.distance_to(grapple_point)
		launched = true
		obj_hit = grapple_raycast.get_collider()
		
		# instantiate rope
		if is_instance_valid(rope_2_node):
			rope_2_node.queue_free()
		rope_2_node = rope_2_script.new()
		rope_2_node.top_level = true
		rope_2_node.global_position = gun_tip.global_position
		rope_2_node.RopeLength = rope_dist * 0.6
		rope_2_node.RopeCollisionBehavior = 1
		add_child(rope_2_node)
		
		# instantiate the grapple point node rope is hooked onto
		if is_instance_valid(rope_2_grapple_point_node):
			rope_2_grapple_point_node.queue_free()
		rope_2_grapple_point_node = Node3D.new()
		
		if obj_hit is RigidBody3D:
			obj_hit.add_child(rope_2_grapple_point_node)
			rope_2_grapple_point_node.position = obj_hit.to_local(grapple_point)
		else:
			#rope_2_grapple_point_node.global_position
			get_tree().current_scene.add_child(rope_2_grapple_point_node)
			rope_2_grapple_point_node.global_position = grapple_point + (grapple_point - global_position).normalized() * 0.02
			
		# attach the rope to the created node3D
		rope_2_node.SetAttachEnd(rope_2_grapple_point_node)

func retract():
	launched = false
	if is_instance_valid(rope_2_node):
		rope_2_node.queue_free()
	if is_instance_valid(rope_2_grapple_point_node):
		rope_2_grapple_point_node.queue_free()

func handle_grapple(delta: float) -> void:
	var target_dist = global_position.distance_to(rope_2_grapple_point_node.global_position)
	var direction_to_grapple = (rope_2_grapple_point_node.global_position - global_position).normalized()
	var velocity_along_rope = velocity.project(direction_to_grapple)
	
	# if its a staticbody, then only pull player velocity
	if obj_hit is StaticBody3D or (obj_hit.mass > pullable_mass):
		
		# take away to opposing vel if we strech past the rope distance
		if (target_dist > rope_dist * 1.01 and velocity.dot(direction_to_grapple) <= 0):
			velocity -= velocity_along_rope * 0.8
			
			# "snap" back to place, increase vel towards the grapple point
			velocity += direction_to_grapple * 35.0 * (target_dist - rope_dist) ** 3
		
		if Input.is_action_pressed("grapple_pull"):
			pull_to(delta)
	
	# else we have to recalculate the player pos from the grapple spot as its moving
	# additionally pull on the object with weight in mind
	elif obj_hit is RigidBody3D:
		if target_dist > rope_dist:

			# Calculate pull force based on object and player mass
			var total_mass = obj_hit.mass + player_mass
			var obj_ratio = obj_hit.mass / total_mass  # How much the object should move
			var player_ratio = player_mass / total_mass  # How much the player should move

			# Compute pull impulse based on stretch amount
			var pull_force = -direction_to_grapple * 35.0 * (target_dist - rope_dist)

			# Apply impulse to both player and object based on their ratios
			#obj_hit.apply_central_force(pull_force * player_ratio)
			obj_hit.apply_force(pull_force * player_ratio * 0.3, obj_hit.to_local(rope_2_grapple_point_node.global_position) * 0.9)
			obj_hit.apply_force(pull_force * player_ratio * 0.7, obj_hit.to_local(rope_2_grapple_point_node.global_position) * 0.5)
			velocity -= 0.05 * pull_force * obj_ratio  # Move player in the opposite direction
			
		if Input.is_action_pressed("grapple_pull"):
			pull_to(delta)
	# update rope pos as well
	rope_2_node.position = gun_tip.global_position

func pull_to(delta: float) -> void:
	if launched and obj_hit:
		
		# do not pull if obj too close
		if (abs((rope_2_grapple_point_node.global_position - global_position).length()) < 2):
			return
			
		var pull_accel = 1.0
		var max_pull_speed = 2.0
		rope_dist = max(rope_dist - pull_accel * delta, 0)
		rope_2_node.RopeLength = rope_dist * 0.6

func toggle_crouch():
	if is_crouching and !shape_cast_crouch.is_colliding():
		crouching(false)
	elif !is_crouching:
		crouching(true)
	
	if shape_cast_crouch.is_colliding():
		print(shape_cast_crouch.get_collider(0))

func crouching(state: bool):
	if state:
		set_speed("crouch")
		animation_player.play("Crouch", 0, crouch_speed)
	elif !state:
		set_speed("walk")
		animation_player.play("Crouch", 0, -crouch_speed, true)

func crouch_check():
	if !shape_cast_crouch.is_colliding():
		crouching(false)
	if shape_cast_crouch.is_colliding():
		await get_tree().create_timer(0.1).timeout
		crouch_check()

# sets 
func set_speed(speed: String):
	match speed:
		"walk":
			player_speed = rel_max_speed
		"crouch":
			player_speed = rel_max_speed_crouch
		"sprint":
			player_speed = rel_max_speed_sprint
	
func set_accel(accel: String):
	match accel:
		"air":
			player_accel = rel_max_accel_air
		"ground":
			player_accel = rel_max_accel_ground
	

# signals
func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if anim_name == "Crouch":
		is_crouching = !is_crouching
