extends Node3D

const BALLAST_GAME_SCENE = preload("res://Van/Prefabs/ballast_minigame.tscn")
const BOILER_GAME_SCENE = preload("res://Van/Prefabs/boiler_minigame.tscn")
const SONAR_GAME_SCENE = preload("res://Levels/sonar_minigame.tscn")
const CIRCUIT_GAME_SCENE = preload("res://Van/Prefabs/circuit_minigame.tscn")

@export var click_indicator_scene: PackedScene = preload("res://Prefabs/UI/click_indicator.tscn")

@onready var camera: Camera3D = $Camera3D
@onready var player: CharacterBody3D = $Player
@onready var ui_layer: CanvasLayer = $UI

var click_indicator: MeshInstance3D = null
var is_mouse_held: bool = false
var is_repair_active: bool = false


func _ready() -> void:
	# Connect to all repair triggers currently registered in the group
	for trigger: RepairTrigger in get_tree().get_nodes_in_group("repair_triggers"):
		if not trigger.launch_minigame_requested.is_connected(_on_repair_requested):
			trigger.launch_minigame_requested.connect(_on_repair_requested)
	
	for trigger: ControlTerminalTrigger in get_tree().get_nodes_in_group("terminal_triggers"):
		if not trigger.terminal_requested.is_connected(_on_terminal_requested):
			trigger.terminal_requested.connect(_on_terminal_requested)
	
	if click_indicator_scene:
		var instance := click_indicator_scene.instantiate()
		click_indicator = instance as MeshInstance3D
		if click_indicator:
			add_child(click_indicator)


# Orchestrates the repair interaction
func _on_repair_requested(system_id: String, trigger: RepairTrigger) -> void:
	print("level.gd received repair request for ", system_id)
	
	# Guard against duplicate emissions while a minigame/transition is in progress
	if is_repair_active:
		print("Request blocked because is_repair_active is TRUE.")
		return
	is_repair_active = true
	
	# 1. Lock player physics and interaction inputs
	if player:
		player.set_physics_process(false)
		player.set_process_unhandled_input(false)
	
	# 2. Transition camera to the station's focus point
	if camera:
		await camera.transition_to_station().finished
	
	# 3. Instantiate the requested minigame overlay
	var game_instance: Control = null
	match system_id:
		"Ballast":
			game_instance = BALLAST_GAME_SCENE.instantiate()
		"Boiler":
			game_instance = BOILER_GAME_SCENE.instantiate()
		"Sonar":
			game_instance = SONAR_GAME_SCENE.instantiate()
		"Circuit":
			game_instance = CIRCUIT_GAME_SCENE.instantiate()
	if not game_instance:
		_restore_control(trigger)
		is_repair_active = false
		return
	
	ui_layer.add_child(game_instance)
	ui_layer.move_child(game_instance, 0)
	
	# 4. Await minigame result signal
	var success: bool = await game_instance.minigame_completed
	
	# 5. Resolve repair state on the station
	trigger.end_repair(success)
	
	# 6. Reset camera and restore player control
	await camera.return_from_station()
	await _restore_control(trigger)
	is_repair_active = false


func _restore_control(trigger: RepairTrigger) -> void:
	# Return camera to original overhead position
	if camera and trigger.camera_focus_point:
		await camera.return_from_station().finished
	
	# Re-enable player movement and interaction
	if player:
		player.set_physics_process(true)
		player.set_process_unhandled_input(true)


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
	if is_mouse_held and !is_repair_active:
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


func _on_terminal_requested(trigger: ControlTerminalTrigger) -> void:
	if player:
		player.set_physics_process(false)
		player.set_process_unhandled_input(false)
	
	var original_camera_transform := Transform3D()
	
	# Explicitly tween to the marker instead of using the generic station zoom
	if camera and trigger.camera_focus_point:
		# Disable the camera's follow logic to prevent transform conflicts
		camera.set_process(false)
		camera.set_physics_process(false)
		
		original_camera_transform = camera.global_transform
		var tween: Tween = create_tween()
		tween.tween_property(camera, "global_transform", trigger.camera_focus_point.global_transform, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		await tween.finished
	
	if trigger.terminal_ui:
		trigger.terminal_ui.visible = true
		await trigger.terminal_ui.terminal_closed
		trigger.terminal_ui.visible = false
	
	# Restore the camera to its original overhead position
	if camera and trigger.camera_focus_point:
		var tween: Tween = create_tween()
		tween.tween_property(camera, "global_transform", original_camera_transform, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		await tween.finished
		
		# Resume the camera's normal follow script
		camera.set_process(true)
		camera.set_physics_process(true)
	
	if player:
		player.set_physics_process(true)
		player.set_process_unhandled_input(true)
