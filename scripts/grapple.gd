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
		pull_to()
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
		#if rope_2_node:
			#rope_2_node.queue_free()
		rope_2_node = rope_2_script.new()
		rope_2_node.position = Vector3(0.7, 0, 0) # set offset to grapple
		rope_2_node.RopeLength = initial_dist * 0.8
		rope_2_node.RopeCollisionBehavior = 1
		get_parent().add_child(rope_2_node)
		
		# instantiate the grapple point node rope is hooked onto
		#if rope_2_grapple_point_node:
			#rope_2_grapple_point_node.queue_free()
		rope_2_grapple_point_node = Node3D.new()
		rope_2_grapple_point_node.global_position = grapple_point + (grapple_point - player.global_position).normalized() * 0.02
		#rope_2_grapple_point_node.global_position = grapple_point
		print(grapple_point)

		# add nodes to the tree
		get_tree().current_scene.add_child(rope_2_grapple_point_node)
		#get_parent().add_child(rope_2_node)
		
		# attach the rope to the created node3D
		rope_2_node.SetAttachEnd(rope_2_grapple_point_node)

func retract():
	launched = false
	#if verlet_rope:
		#verlet_rope.queue_free()
		#verlet_rope = null
	if is_instance_valid(rope_2_node):
		rope_2_node.queue_free()
	if is_instance_valid(rope_2_grapple_point_node):
		rope_2_grapple_point_node.queue_free()
	
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

	
func pull_to():
	
	# check if the grapple is attached to something
	if launched and obj_hit:
		# do not pull if obj too close
		if (abs((grapple_point - player.global_position).length()) < 2):
			return
			
			
		var direction = (grapple_point - player.global_position).normalized()
		
		# if a staticbody, pull player towards it
		if obj_hit is StaticBody3D:
			var prev_player_pos = player.global_position
			player.velocity += direction * 0.25
			initial_dist = max(initial_dist - (player.global_position - prev_player_pos).length(), 0.0)
			print("pulling player")

		# if a rigidbody, pull it towards player
		elif obj_hit is RigidBody3D:
			var prev_obj_pos = obj_hit.global_position
			obj_hit.apply_central_impulse(- direction * 0.25)
			initial_dist = max(initial_dist - (obj_hit.global_position - prev_obj_pos).length(), 0.0)
			print("pulling object")
		
		rope_2_node.RopeLength = initial_dist
		

# draw the rope
func update_rope():
	if !launched:
		rope.visible = false
		if verlet_rope:
			verlet_rope.visible = false
		return
