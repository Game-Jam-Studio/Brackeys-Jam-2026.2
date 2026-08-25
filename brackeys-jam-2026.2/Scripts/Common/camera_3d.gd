extends Camera3D

@export var player_character: CharacterBody3D
@export var follow_speed: float = 8.0

var fixed_height: float
var horizontal_offset: Vector2
var return_transform: Transform3D
var active_tween: Tween

func _ready() -> void:
	make_current()
	
	if player_character:
		# Lock the fixed world Y-position to wherever the camera is in the editor
		fixed_height = global_position.y
		
		# Record the relative X & Z distance between camera and player
		horizontal_offset = Vector2(
			global_position.x - player_character.global_position.x,
			global_position.z - player_character.global_position.z
		)


func _physics_process(delta: float) -> void:
	if not player_character:
		return
	
	# Calculate the target position using player X/Z + offset, while keeping fixed world Y
	var target_position := Vector3(
		player_character.global_position.x + horizontal_offset.x,
		fixed_height,
		player_character.global_position.z + horizontal_offset.y
	)
	
	# Interpolate toward the target position for smooth tracking.
	global_position = global_position.lerp(target_position, follow_speed * delta)


func transition_to_station(focus_point: Node3D, duration: float = 0.6) -> Tween:
	# Cache the current overhead transform before moving
	return_transform = global_transform
	
	# Stop any running tween to avoid conflicts
	if active_tween and active_tween.is_running():
		active_tween.kill()
	
	active_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	active_tween.tween_property(self, "global_transform", focus_point.global_transform, duration)
	return active_tween


func return_from_station(duration: float = 0.6) -> Tween:
	# Stop any running tween to avoid conflicts
	if active_tween and active_tween.is_running():
		active_tween.kill()
	
	active_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	active_tween.tween_property(self, "global_transform", return_transform, duration)
	return active_tween
