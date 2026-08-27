extends CharacterBody3D

@export var can_move : bool = true
@export var base_speed : float = 6.0
@export var rotation_speed : float = 12.0

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var animation_tree: AnimationTree = $AnimationTree

var has_active_target : bool = false
var start_position : Vector3
var new_velocity : Vector3


func set_movement_target(target_position: Vector3) -> void:
	nav_agent.target_position = target_position
	has_active_target = true
	start_position = global_position


func _physics_process(delta: float) -> void:
	animation_tree["parameters/MovementBlend/blend_position"] = velocity.length() / 4
	if not can_move or not has_active_target:
		return

	if nav_agent.is_navigation_finished():
		has_active_target = false
		velocity = Vector3.ZERO
		move_and_slide()
		return
		
	var current_position := global_position
	var next_path_position := nav_agent.get_next_path_position()
	new_velocity = (next_path_position - current_position)
	new_velocity.y = 0.0


	if new_velocity.length() > 0:
		var movement_direction := new_velocity.normalized()
		if (nav_agent.target_position - start_position).length() / 1.01 < (nav_agent.target_position - current_position).length():
			velocity.x = movement_direction.x * base_speed * clamp((nav_agent.target_position - current_position).length() / 3, 0, 1)
			velocity.z = movement_direction.z * base_speed * clamp((nav_agent.target_position - current_position).length() / 3, 0, 1)
		else:
			velocity.x = movement_direction.x * base_speed
			velocity.z = movement_direction.z * base_speed
		
		var target_angle := atan2(movement_direction.x, movement_direction.z)
		rotation.y = lerp_angle(rotation.y, target_angle, rotation_speed * delta)
	else:
		velocity.x = 0.0
		velocity.z = 0.0
		
	move_and_slide()
	
	var animation_vector := Vector2(velocity.x, velocity.z)
