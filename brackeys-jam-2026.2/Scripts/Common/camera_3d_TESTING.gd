extends Camera3D

@export var player_character: CharacterBody3D
@export var follow_speed: float = 8.0

@export var rotation_speed: float = 4
@export var max_camera_lerp_distance: float = 15
@export var max_camera_speed: float = 5

var fixed_height: float
var horizontal_offset: Vector2
var return_transform: Transform3D
var active_tween: Tween

var vector_to_camera: Vector3

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
		
		vector_to_camera = global_position - player_character.global_position


func _physics_process(delta: float) -> void:
	if not player_character:
		return
	
	# camera rotation smoothing
	var target_direction = global_transform.looking_at(player_character.global_position, Vector3.UP)
	
	var current_quaternion = global_transform.basis.get_rotation_quaternion()
	var target_quaternion = target_direction.basis.get_rotation_quaternion()
	
	var smooth_quaternion = current_quaternion.slerp(target_quaternion, rotation_speed * delta)
	
	global_transform.basis = Basis(smooth_quaternion)
	
	# camera position smoothing
	var target_position = player_character.global_position + player_character.global_transform.basis * vector_to_camera
	
	var invertedWeight = 1 - clamp((target_position-global_position).length()/max_camera_lerp_distance, 0, 1)
	
	# Interpolate toward the target position for smooth tracking.
	var distance_to_move = global_position.lerp(target_position, invertedWeight * follow_speed * delta) - global_position
	distance_to_move = distance_to_move.normalized() * clamp(distance_to_move.length(), 0, max_camera_speed)
	global_position += distance_to_move


func transition_to_station(duration: float = 0.6) -> Tween:
	# Cache the current overhead transform before moving
	return_transform = global_transform
	
	# Stop any running tween to avoid conflicts
	if active_tween and active_tween.is_running():
		active_tween.kill()
	
	active_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	active_tween.tween_property(self, "fov", 20, duration)
	return active_tween


func return_from_station(duration: float = 0.6) -> Tween:
	# Stop any running tween to avoid conflicts
	if active_tween and active_tween.is_running():
		active_tween.kill()
	
	active_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	active_tween.tween_property(self, "fov", 75, duration)
	return active_tween
