extends CharacterBody3D

@export var can_move : bool = true
@export var base_speed : float = 6.0
@export var rotation_speed : float = 12.0

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

var has_active_target : bool = false


func set_movement_target(target_position: Vector3) -> void:
	print_debug("1. Target received: ", target_position)
	nav_agent.target_position = target_position
	has_active_target = true
	print_debug("2. Is target reachable: ", nav_agent.is_target_reachable())
	print_debug("3. Distance to target: ", nav_agent.distance_to_target())


func _physics_process(delta: float) -> void:
	if not can_move or not has_active_target:
		return

	if nav_agent.is_navigation_finished():
		print_debug("Navigation finished reached.")
		has_active_target = false
		velocity = Vector3.ZERO
		move_and_slide()
		update_animations(Vector2.ZERO)
		return

	var current_position := global_position
	var next_path_position := nav_agent.get_next_path_position()
	var new_velocity := (next_path_position - current_position)
	new_velocity.y = 0.0

	print_debug("Process frame -> Current: ", current_position, " | Next: ", next_path_position, " | Dist: ", new_velocity.length())

	if new_velocity.length() > 0.05:
		var movement_direction := new_velocity.normalized()
		velocity.x = movement_direction.x * base_speed
		velocity.z = movement_direction.z * base_speed

		var target_angle := atan2(movement_direction.x, movement_direction.z)
		rotation.y = lerp_angle(rotation.y, target_angle, rotation_speed * delta)
	else:
		velocity.x = 0.0
		velocity.z = 0.0

	move_and_slide()

	var animation_vector := Vector2(velocity.x, velocity.z)
	update_animations(animation_vector)


func update_animations(animation_vector: Vector2) -> void:
	if not anim_player:
		return

	if animation_vector.length() > 0.1:
		if anim_player.has_animation("Player/Walking_A") and anim_player.current_animation != "Player/Walking_A":
			anim_player.play("Player/Walking_A", 0.2)
	else:
		if anim_player.has_animation("Player/Idle_A") and anim_player.current_animation != "Player/Idle_A":
			anim_player.play("Player/Idle_A", 0.2)
