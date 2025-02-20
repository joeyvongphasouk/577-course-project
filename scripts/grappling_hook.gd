extends Node3D

# got this code from https://www.youtube.com/watch?v=07tfCS_RRGM

@onready var rope: MeshInstance3D = $RopeRoot/Rope
@onready var rope_root: Node3D = $RopeRoot
@onready var player: CharacterBody3D = get_parent().get_parent()  # Get the parent of the hook, which is the player


var is_grappled: bool
var grapple_target: PhysicsBody3D
var grapple_point_local_pos: Vector3
var acceleration: float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rope.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	process_input()
	process_grapple()

func process_input():
	if Input.is_action_just_pressed("grapple"):
		if is_grappled:
			is_grappled = false
			rope.visible = false
			grapple_point_local_pos = Vector3.ZERO
			grapple_target = null
			global_rotation_degrees = Vector3.ZERO
			
		else:
			var from = global_position
			var forward = -global_basis.z
			var to = global_position + forward * 500
			var raycast_result = get_world_3d().direct_space_state.intersect_ray(
				PhysicsRayQueryParameters3D.create(from, to)
			)
			
			# check if we hit something
			if not raycast_result.is_empty():
				var node_hit = raycast_result["collider"] as PhysicsBody3D  # Corrected cast
				if node_hit:
					grapple_target = node_hit
					grapple_point_local_pos = node_hit.to_local(raycast_result["position"])
					is_grappled = true
					rope.visible = true


#func process_input():
	#if Input.is_action_just_pressed("grapple"):
		#if is_grappled:
			#is_grappled = false
			#rope.visible = false
			#grapple_point_local_pos = Vector3.ZERO
			#grapple_target = null
		#else:
			#var from = global_position
			#var forward = -global_basis.z
			#var to = global_position + forward * 500
			#var raycast_result = get_world_3d().direct_space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from, to))
			#
			## check if we hit something
			#if not raycast_result.is_empty():
				#var node_hit = raycast_result["collider"] as Node3D
				#if node_hit is PhysicsBody3D:
					#grapple_target = node_hit
					#grapple_point_local_pos = node_hit.to_local(raycast_result["position"] as Vector3)
					#is_grappled = true
					#rope.visible = true

func process_grapple():
	if is_grappled:
		var grapple_point_global_pos = grapple_target.to_global(grapple_point_local_pos)
		look_at(grapple_point_global_pos)

		var displacement = global_position - grapple_point_global_pos
		rope.scale = Vector3(1.0, 1.0, displacement.length())

		# Apply force using velocity
		if player:
			var force = displacement.normalized() * acceleration
			player.velocity = force  # Apply the force directly to the player's velocity
		else:
			print("Error: player is null!")
