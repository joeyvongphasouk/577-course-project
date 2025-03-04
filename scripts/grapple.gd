extends Node3D

@onready var player: CharacterBody3D = $".."
@onready var ray_cast_3d: RayCast3D = $"../Head/RayCast3D"
@onready var rope: Node3D = $"../Head/Camera3D/Rope"

# this is for things involving rope springiness if needed
@export var rest_length: float = 2.0
@export var stiffness: float = 10.0
@export var damping: float = 1.0

var launched: bool = false
var grapple_point: Vector3
var obj_hit: CollisionObject3D

var initial_dist: float
var verlet_rope: Node3D
@export var rope_scene: PackedScene

var rope_2_script
var rope_2_node: Node3D
var rope_2_grapple_point_node: Node3D

func _ready() -> void:
	rope_2_script = load("res://addons/verlet_rope_4/VerletRope.cs")

func _physics_process(delta: float) -> void:
	# deploy/retract grapple
	if Input.is_action_just_pressed("grapple_attach"):
		launch()
	if Input.is_action_just_released("grapple_attach"):
		retract()
		
	# handle grapple mech
	if Input.is_action_pressed("grapple_pull"):
		pull_to(delta)
	if launched:
		handle_grapple(delta)
	
	# need to physically update the rope shown on screen
	update_rope()

func launch():
	if ray_cast_3d.is_colliding():
		grapple_point = ray_cast_3d.get_collision_point()
		initial_dist = player.global_position.distance_to(grapple_point)
		launched = true
		obj_hit = ray_cast_3d.get_collider()
		
		# instantiate rope
		if is_instance_valid(rope_2_node):
			rope_2_node.queue_free()
		rope_2_node = rope_2_script.new()
		rope_2_node.position = Vector3(0.7, 0, 0) # set offset to grapple
		rope_2_node.RopeLength = initial_dist * 0.8
		rope_2_node.RopeCollisionBehavior = 1
		get_parent().add_child(rope_2_node)
		
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
			rope_2_grapple_point_node.global_position = grapple_point + (grapple_point - player.global_position).normalized() * 0.02
			
		# attach the rope to the created node3D
		rope_2_node.SetAttachEnd(rope_2_grapple_point_node)

func retract():
	launched = false
	if is_instance_valid(rope_2_node):
		rope_2_node.queue_free()
	if is_instance_valid(rope_2_grapple_point_node):
		rope_2_grapple_point_node.queue_free()
	
func handle_grapple(delta: float):
	#var target_dir = player.global_position.direction_to(grapple_point)
	
	# could look to set the max length of rope and "dangle" the rope
	# 	needs segmented rope model
	# additionally, if a player is going past the initial dist,
	# then apply a force in opp dir to simulate "rope stretchcing" + newt 3rd
	
	# check if stationary, if so, then pull only the player
	# can perform kinematics cause stationary obj
	# would need to use forces if we want player mass to be a thing
	if obj_hit is StaticBody3D:
		var offset = player.global_position - grapple_point
		var target_dist = player.global_position.distance_to(grapple_point)
		
		if (target_dist > initial_dist):
			player.global_position = grapple_point + offset.normalized() * initial_dist
			player.velocity = player.velocity.slide(offset.normalized())
	
	# else we have to calculate the player pos from the grapple spot as its moving
	else:
		## recalc player pos from where grapple point is
		#var offset = player.global_position - rope_2_grapple_point_node.global_position
		#var target_dist = player.global_position.distance_to(rope_2_grapple_point_node.global_position)
		#
		## next move the object if the rope length is shorter
		##if (target_dist > initial_dist):
			##print("rope stretched")
			##player.global_position = grapple_point + offset.normalized() * initial_dist
			##player.velocity = player.velocity.slide(offset.normalized())
			
		var offset = player.global_position - rope_2_grapple_point_node.global_position
		var target_dist = player.global_position.distance_to(rope_2_grapple_point_node.global_position)

		if target_dist > initial_dist:
			var direction = (rope_2_grapple_point_node.global_position - player.global_position).normalized()

			# Player gets pulled
			player.velocity += direction * 5.0  # Adjust force applied to player

			# Object gets pulled (but scaled by mass)
			if obj_hit is RigidBody3D:
				var force = direction * 10.0 / obj_hit.mass  # Scale force by inverse of mass
				obj_hit.apply_central_force(force)

	
func pull_to(delta: float):
	
	# check if the grapple is attached to something
	if launched and obj_hit:
		# do not pull if obj too close
		if (abs((grapple_point - player.global_position).length()) < 2):
			return

		# if stationary, pull player to obj
		#if obj_hit is StaticBody3D:
			
		var direction = (grapple_point - player.global_position).normalized()
		var force = direction * 2.0 # scale the norm vec by 2, cause pull is too slow

		var displacement = force * delta
		initial_dist = max(initial_dist - displacement.length(), 0.0)

		## if moveable, pull obj to player
		#elif obj_hit is RigidBody3D:
			#
			#var direction = (player.global_position - grapple_point).normalized()
			#grapple_point = rope_2_grapple_point_node.global_position
			#
			## Define the desired constant speed (change as needed)
			#var desired_speed = 5.0
#
			## Compute required force based on mass
			#var pull_force = direction * 10.0  # 10.0 is an arbitrary force strength, adjust as needed
			#obj_hit.apply_central_force(pull_force)
#
			## **Velocity Clamping**: Ensure the object does not exceed the desired speed
			#var current_velocity = obj_hit.linear_velocity
			#var velocity_toward_player = current_velocity.project(direction)  # Get movement along pull direction
#
			## If the object is moving too fast toward the player, slow it down
			#if velocity_toward_player.length() > desired_speed:
				#obj_hit.linear_velocity = velocity_toward_player.normalized() * desired_speed
#
			### Calculate pull strength based on mass
			##var pull_force = 5.0 * direction
			##var force = direction * 2 * obj_hit.mass / delta  # Heavier objects move slower
			##print(pull_force)
			##print(force)
			##obj_hit.apply_central_force(pull_force)
##
			### Apply impulse to the object
			### use newt 2nd law a = f/m to see if such will move
			### if it will move, apply the force onto the object
			### if it does not move, apply the force onto the player, but do not change grapple
			##if (pull_force / obj_hit.mass).length() > 0.01:
				##obj_hit.apply_central_force(pull_force)
				###initial_dist = max(initial_dist - displacement.length(), 0.0)
			##else:
				##var offset = player.global_position - grapple_point
				##var target_dist = player.global_position.distance_to(grapple_point)
				##
				##if (target_dist > initial_dist):
					##player.global_position = grapple_point + offset.normalized() * initial_dist
					##player.velocity = player.velocity.slide(offset.normalized())
#
#
			### Optional: Apply opposite reaction force to the player (Newton's 3rd law)
			##player.velocity -= force * 0.5  # Scale down so player isn't thrown too fast
			#
			##var displacement = force * delta
			##initial_dist = max(initial_dist - displacement.length(), 0.0)

		# Update rope length (this controls the visual rope length)
		rope_2_node.RopeLength = initial_dist * 0.8

# draw the rope
func update_rope():
	pass
	#if !launched:
		#rope.visible = false
		#if verlet_rope:
			#verlet_rope.visible = false
		#return
