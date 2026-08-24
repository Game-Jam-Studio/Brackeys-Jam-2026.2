extends Node3D

@onready var camera: Camera3D = $Camera3D
@onready var player: CharacterBody3D = $Player


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if not camera:return
			if not player: return
			
			var mouse_pos = event.position
			var ray_origin = camera.project_ray_origin(mouse_pos)
			var ray_normal = camera.project_ray_normal(mouse_pos)
			var ray_length := 1000.0
			
			var space_state := get_world_3d().direct_space_state
			var query := PhysicsRayQueryParameters3D.create(ray_origin, ray_origin + ray_normal * ray_length)
			query.exclude = [player.get_rid()]
			
			var result := space_state.intersect_ray(query)
			
			if result:
				player.set_movement_target(result.position)
