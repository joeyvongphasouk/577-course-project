class_name Player
extends CharacterBody3D

@onready var head: Node3D = $Head
@onready var camera_3d: Camera3D = $Head/Camera3D
@onready var grapple_raycast: RayCast3D = $Head/GrappleRaycast

#@onready var grapple_gun_anim: AnimationPlayer = $Head/Camera3D/WeaponRig/grapple_gun/AnimationPlayer
#@onready var fire_node: Node3D = $Head/Camera3D/WeaponRig/grapple_gun/GunTip/fire_node
#@onready var static_flame: GPUParticles3D = $Head/Camera3D/WeaponRig/grapple_gun/GunTip/fire_node/static_flame
#@onready var gun_tip: Node3D = $Head/Camera3D/WeaponRig/grapple_gun/GunTip

@onready var grapple_gun_anim: AnimationPlayer = $WeaponRig/grapple_gun/AnimationPlayer
@onready var fire_node: Node3D = $WeaponRig/grapple_gun/GunTip/fire_node
@onready var static_flame: GPUParticles3D = $WeaponRig/grapple_gun/GunTip/fire_node/static_flame
@onready var gun_tip: Node3D = $WeaponRig/grapple_gun/GunTip

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
@export var rel_max_accel_sprint: float =  200.0
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

@export_group("Other various things")
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

# character model
@onready var raider_player_model: Node3D = $RaiderPlayerModel

# respawn death areas
@export var respawn_trigger: Array [Node]

var sticky_jump: bool
var sticky_norm: Vector3

# interaction stuff
@onready var interaction_raycast: RayCast3D = $Head/InteractionRaycast
var interact_cast_result: Node = null
var last_highlighted: Node = null

func _ready() -> void:
	GlobalPlayer.player = self
	shape_cast_crouch.add_exception($".")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# spawn in rope
	# use always use this rope instead of deleting and spawning back in ropes
	# nvm, rope glitches from previous place
	rope_2_script = load("res://addons/verlet_rope_4/VerletRope.cs")
	rope_2_grapple_point_node = Node3D.new()
	
	#rope_2_node.hide()
	rope_2_grapple_point_node.hide()
	
	# handle fire instantiation
	static_flame.visible = false
	fire_node.visible = false
	sticky_jump = false
	
	# handle respawn instantiation
	for elem in respawn_trigger:
		elem.respawn_signal.connect(_respawn)
	
func _unhandled_input(event) -> void:
	# Look around
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensitivity)
		head.rotation.x = head.rotation.x - event.relative.y * sensitivity
		
		# dont want to spin all the way
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _input(event: InputEvent) -> void:
	# add option to extinguish fire from gun
	if event.is_action_pressed("extinguish"):
		fire_node.visible = false
		print("extinguish")
	
	# toggle crouch
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
	if Input.is_action_just_pressed("ui_accept"):
		if sticky_jump:
			velocity.y += 0.6 * jump_force
			velocity += 0.5 * jump_force * sticky_norm
			sticky_norm = Vector3.ZERO
			
		elif is_on_floor():
			velocity.y += jump_force
	
	sticky_jump = false
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# orig way of going about it is to approach max speed in dir by linear interp
	# instead accel when there is an input, have less accel in the air
	if input_dir.length() != 0:
		
		# set move_speed and move_accel vars based on state of player
		if is_on_floor():
			set_accel("ground")
			if Input.is_action_pressed("sprint"):
				set_speed("sprint")
			else:
				set_speed("walk")
		else:
			set_accel("air")
			
		var horizontal_speed := Vector2(velocity.x, velocity.z).length()
		var speed_threshold = player_speed * 1.2  # Tune this factor
		var control_factor = clamp(1.0 - (horizontal_speed / speed_threshold), 0.2, 1.0)

		
		velocity.x = lerpf(velocity.x, direction.x * player_speed, player_accel * delta * control_factor)
		velocity.z = lerpf(velocity.z, direction.z * player_speed, player_accel * delta * control_factor)

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
	
	interaction_handle(delta)
		
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
			pass
			#print("col obj norm:", c.get_normal(), "| col rem vec:", c.get_remainder(), "| play vec:", velocity)
		
		if c.get_collider().is_in_group("Sticky"):
			sticky_jump = true
			var collision_normal = c.get_normal()
			sticky_norm += collision_normal
			sticky_norm = sticky_norm.normalized()

			var vel_into_wall = velocity.project(collision_normal)
			velocity -= vel_into_wall

			velocity *= 0.8

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
		
		# check to see if the collider is colliding with valid objects
		# ie. pass if the collider detects invalid area3d spaces
		obj_hit = grapple_raycast.get_collider()
		if obj_hit is Area3D:
			if obj_hit.is_in_group("fire_source"):
				
				# light the grapple on fire
				if obj_hit.get_parent().lit:
					fire_node.visible = true
					print("fire")
				
				# light the brazier on fire
				elif !obj_hit.get_parent().lit and fire_node.visible:
					obj_hit.get_parent().light()
					
			else:
				return
		
		grapple_point = grapple_raycast.get_collision_point()
		rope_dist = global_position.distance_to(grapple_point)
		launched = true
		
		# unhide and update rope
		if is_instance_valid(rope_2_node):
			rope_2_node.queue_free()
		rope_2_node = rope_2_script.new()
		rope_2_node.top_level = true
		if is_instance_valid(gun_tip):
			rope_2_node.global_position = gun_tip.global_position
		rope_2_node.RopeCollisionBehavior = 1
		rope_2_node.RopeLength = rope_dist * 0.6
		add_child(rope_2_node)

		obj_hit.add_child(rope_2_grapple_point_node)
		rope_2_grapple_point_node.position = obj_hit.to_local(grapple_point)
		
		# attach the rope to the created node3D
		rope_2_node.SetAttachEnd(rope_2_grapple_point_node)
		
		rope_2_node.show()
		rope_2_grapple_point_node.show()
		
		# move the guntip to the global point where rope_2_grapple_point_node exists


func retract():
	if launched:
		launched = false
		
		# instead of deleting which takes up computation
		# just hide the rope
		rope_2_grapple_point_node.global_position = gun_tip.global_position
		obj_hit.remove_child(rope_2_grapple_point_node)
		rope_2_grapple_point_node.hide()
		
		if is_instance_valid(rope_2_node):
			rope_2_node.queue_free()
		#if is_instance_valid(rope_2_grapple_point_node):
			#rope_2_grapple_point_node.queue_free()

func handle_grapple(delta: float) -> void:
	var target_dist = global_position.distance_to(rope_2_grapple_point_node.global_position)
	var direction_to_grapple = (rope_2_grapple_point_node.global_position - global_position).normalized()
	var velocity_along_rope = velocity.project(direction_to_grapple)
	
	# if its a staticbody or mass is heavy or an area3d,
	# then only pull player velocity
	if obj_hit is Area3D or obj_hit is StaticBody3D or (obj_hit.mass > pullable_mass):
		
		# take away to opposing vel if we strech past the rope distance
		if (target_dist > rope_dist * 1.01 and (velocity.dot(direction_to_grapple) <= 0 or velocity.length() < 0.5)):
			#velocity -= velocity_along_rope * 0.8
			velocity -= velocity_along_rope
			#print(direction_to_grapple * 35.0 * (target_dist - rope_dist) ** 3)
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
			
		var pull_accel = 1.5
		var max_pull_speed = 6.0
		rope_dist = max(rope_dist - pull_accel * delta, 0)
		rope_2_node.RopeLength = rope_dist * 0.6
		
		# slightly increase the player's vel towards the object
		velocity += 0.001 * (grapple_point - global_position)

func interaction_handle(delta: float) -> void:
	if interaction_raycast.is_colliding():
		interact_cast_result = interaction_raycast.get_collider()

		if interact_cast_result != last_highlighted:
			# Unhighlight previous object
			if last_highlighted != null and last_highlighted.has_method("highlight"):
				last_highlighted.highlight(false)

			# Highlight new object if possible
			if interact_cast_result.has_method("highlight"):
				interact_cast_result.highlight(true)

			# Update the last highlighted object
			last_highlighted = interact_cast_result

		# Handle pickup if interact button pressed
		if Input.is_action_just_pressed("interact") and interact_cast_result.has_method("pickup"):
			interact_cast_result.pickup()

	else:
		# No collision, unhighlight if needed
		if last_highlighted != null and last_highlighted.has_method("highlight"):
			last_highlighted.highlight(false)
			last_highlighted = null

			interact_cast_result = null






func toggle_crouch():
	if is_crouching and !shape_cast_crouch.is_colliding():
		crouching(false)
	elif !is_crouching:
		crouching(true)

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

func _respawn() -> void:
	get_tree().reload_current_scene()
