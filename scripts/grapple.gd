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

var initial_dist: float;

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("grapple"):
		launch()
	if Input.is_action_just_released("grapple"):
		retract()
	
	# handle the player physics
	if launched:
		handle_grapple(delta)
	
	# need to physically update the rope shown on screen
	update_rope()

func launch():
	if ray_cast_3d.is_colliding():
		grapple_point = ray_cast_3d.get_collision_point()
		initial_dist = player.global_position.distance_to(grapple_point)
		launched = true


func retract():
	launched = false
	
func handle_grapple(delta: float):
	var target_dir = player.global_position.direction_to(grapple_point)
	var target_dist = player.global_position.distance_to(grapple_point)
	
	var displacement = target_dist - rest_length
	var force = Vector3.ZERO
	
	# could look to set the max length of rope and "dangle" the rope
	# 	needs segmented rope model
	# additionally, if a player is going past the initial dist,
	# then apply a force in opp dir to simulate "rope stretchcing" + newt 3rd
	
	# apply opp force if rope is stretching / player going against rope
	var offset = player.global_position - grapple_point
	if (target_dist > initial_dist ):
		player.global_position = grapple_point + offset.normalized() * initial_dist
		player.velocity = player.velocity.slide(offset.normalized())
		#player.global_position = anchor_point + offset.normalized() * max_rope_length
		#velocity = velocity.slide(offset.normalized())  # Slide along the rope boundary
	
	
	
	# the video looks to implement the rope as a spring
	# idk if we want that or not
	# rope is stretched
	#if displacement > 0:
		#var spring_force_magnitude = stiffness * displacement
		#var spring_force = target_dir * spring_force_magnitude
		#
		#var vel_dot = player.velocity.dot(target_dir)
		#var damping = -damping * vel_dot * target_dir
		#
		#force = spring_force + damping
		#
	#player.velocity += force * delta
	

	
	
	

func update_rope():
	if !launched:
		rope.visible = false
		return
	
	# video does grapple dist based on player, but want to do so from
	# global rope pos instead
	rope.visible = true
	var dist = rope.global_position.distance_to(grapple_point) / 2
	rope.look_at(grapple_point)
	rope.scale = Vector3(1, 1, dist)
	
		

#
#var grapple_cd: float = 5
#var grapple_cd_timer: float = 0
#var grappling: bool = false
#var grapple_point: Vector3
#var grapple_distance
#
#func _physics_process(delta: float) -> void:
	#grapple_distance = abs(ray_cast_3d.target_position.y)
	#if Input.is_action_just_pressed("grapple"):
		#start_grapple()
	##if grapple_cd_timer > 0:
		##grapple_cd_timer -= delta
#
#
#func start_grapple() -> void:
	#grappling = true
	#if ray_cast_3d.is_colliding():
		#grapple_point = ray_cast_3d.get_collision_point()
		#print(grapple_point)
		#execute_grapple()
	#else:
		#grapple_point = head.position + head.rotation * grapple_distance
		#stop_grapple()
		#
#func execute_grapple() -> void:
	#pass
#func stop_grapple() -> void:
	#grappling = true
	#grapple_cd_timer = grapple_cd
	#
#






# got this code from https://www.youtube.com/watch?v=07tfCS_RRGM

#@onready var rope: MeshInstance3D = $RopeRoot/Rope
#@onready var rope_root: Node3D = $RopeRoot
#@onready var player: CharacterBody3D = get_parent().get_parent()  # Get the parent of the hook, which is the player
#
#
#var is_grappled: bool
#var grapple_target: PhysicsBody3D
#var grapple_point_local_pos: Vector3
#var acceleration: float = 10.0
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#rope.visible = false
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
#
#func _physics_process(delta: float) -> void:
	#process_input()
	#process_grapple()
#
#func process_input():
	#if Input.is_action_just_pressed("grapple"):
		#if is_grappled:
			#is_grappled = false
			#rope.visible = false
			#grapple_point_local_pos = Vector3.ZERO
			#grapple_target = null
			#global_rotation_degrees = Vector3.ZERO
			#
		#else:
			#var from = global_position
			#var forward = -global_basis.z
			#var to = global_position + forward * 500
			#var raycast_result = get_world_3d().direct_space_state.intersect_ray(
				#PhysicsRayQueryParameters3D.create(from, to)
			#)
			#
			## check if we hit something
			#if not raycast_result.is_empty():
				#var node_hit = raycast_result["collider"] as PhysicsBody3D  # Corrected cast
				#if node_hit:
					#grapple_target = node_hit
					#grapple_point_local_pos = node_hit.to_local(raycast_result["position"])
					#is_grappled = true
					#rope.visible = true
#
#
##func process_input():
	##if Input.is_action_just_pressed("grapple"):
		##if is_grappled:
			##is_grappled = false
			##rope.visible = false
			##grapple_point_local_pos = Vector3.ZERO
			##grapple_target = null
		##else:
			##var from = global_position
			##var forward = -global_basis.z
			##var to = global_position + forward * 500
			##var raycast_result = get_world_3d().direct_space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from, to))
			##
			### check if we hit something
			##if not raycast_result.is_empty():
				##var node_hit = raycast_result["collider"] as Node3D
				##if node_hit is PhysicsBody3D:
					##grapple_target = node_hit
					##grapple_point_local_pos = node_hit.to_local(raycast_result["position"] as Vector3)
					##is_grappled = true
					##rope.visible = true
#
#func process_grapple():
	#if is_grappled:
		#var grapple_point_global_pos = grapple_target.to_global(grapple_point_local_pos)
		#look_at(grapple_point_global_pos)
#
		#var displacement = global_position - grapple_point_global_pos
		#rope.scale = Vector3(1.0, 1.0, displacement.length())
#
		## Apply force using velocity
		#if player:
			#var force = displacement.normalized() * acceleration
			#player.velocity = force  # Apply the force directly to the player's velocity
		#else:
			#print("Error: player is null!")
