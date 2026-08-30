extends HBoxContainer

@export var alert_icon_scene: PackedScene

@export var ballast_icon: Texture2D
@export var boiler_icon: Texture2D
@export var sonar_icon: Texture2D
@export var circuit_icon: Texture2D

func _ready() -> void:
	# Listen for global breakdown events from GameState
	GameState.system_state_changed.connect(_on_system_state_changed)

func _on_system_state_changed(system_id: String, is_broken: bool) -> void:
	# Route the event to the appropriate add or remove function
	if is_broken:
		_add_alert_icon(system_id)
	else:
		_remove_alert_icon(system_id)

func _add_alert_icon(system_id: String) -> void:
	# Iterate through existing children to prevent duplicate icons for the same system
	for child in get_children():
		if child.has_meta("system_id") and child.get_meta("system_id") == system_id:
			return
			
	# Instantiate the icon scene
	var icon = alert_icon_scene.instantiate()
	
	# Tag the instance sso it can be identified for removal later
	icon.set_meta("system_id", system_id)
	
	# Apply the system colors & icon
	match system_id:
		"Ballast": 
			icon.texture = ballast_icon
			icon.modulate = Color(0.494, 0.894, 0.329, 1.0)
		"Boiler": 
			icon.texture = boiler_icon
			icon.modulate = Color(0.988, 0.42, 0.008, 1.0)
		"Sonar": 
			icon.texture = sonar_icon
			icon.modulate = Color(0.184, 0.651, 1.0, 1.0)
		"Circuit": 
			icon.texture = circuit_icon
			icon.modulate = Color(1.0, 0.973, 0.035, 1.0)
		
	# Add the initialized icon node as a child of this container
	add_child(icon)
	
	# Shift the newly added node to the first index position (far left)
	move_child(icon, 0)

func _remove_alert_icon(system_id: String) -> void:
	# Iterate through the container's children to find the matching icon
	for child in get_children():
		if child.has_meta("system_id") and child.get_meta("system_id") == system_id:
			# Safely delete the node from the scene tree
			child.queue_free()
			break
