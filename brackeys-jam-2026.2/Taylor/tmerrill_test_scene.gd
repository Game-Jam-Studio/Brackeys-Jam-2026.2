extends Node3D

@export var click_indicator_scene: PackedScene = preload("res://Prefabs/UI/click_indicator.tscn")

@onready var camera: Camera3D = $Camera3D
@onready var player: CharacterBody3D = $Player

var click_indicator: MeshInstance3D = null
var is_mouse_held: bool = false


func _ready() -> void:
	if click_indicator_scene:
		var instance := click_indicator_scene.instantiate()
		click_indicator = instance as MeshInstance3D
		if click_indicator:
			add_child(click_indicator)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_mouse_held = true
			var hit_position: Vector3 = raycast_to_floor(event.position)
			if hit_position != Vector3.INF:
				player.set_movement_target(hit_position)
				if click_indicator:
					click_indicator.play_click_ping(hit_position)
		else:
			is_mouse_held = false
			if click_indicator:
				click_indicator.finish_hold()


func _physics_process(_delta: float) -> void:
	if is_mouse_held:
		var current_mouse_position := get_viewport().get_mouse_position()
		var hit_position: Vector3 = raycast_to_floor(current_mouse_position)
		if hit_position != Vector3.INF:
			player.set_movement_target(hit_position)
			if click_indicator:
				click_indicator.update_hold_position(hit_position)


func raycast_to_floor(screen_position: Vector2) -> Vector3:
	if not camera or not player:
		return Vector3.INF
	
	var ray_origin := camera.project_ray_origin(screen_position)
	var ray_normal := camera.project_ray_normal(screen_position)
	var ray_length := 1000.0
	
	var space_state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(ray_origin, ray_origin + ray_normal * ray_length)
	query.exclude = [player.get_rid()]
	
	var result := space_state.intersect_ray(query)
	if result:
		return result.position
	return Vector3.INF
	
