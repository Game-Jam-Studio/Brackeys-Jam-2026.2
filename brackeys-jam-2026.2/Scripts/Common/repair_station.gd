@tool
class_name RepairStation
extends Node3D

var flash_tween: Tween

@export_enum("Ballast", "Boiler", "Sonar", "Circuit") var system_id: String = "Ballast":
	set(value):
		system_id = value
		# Only access nodes if this instance is loaded into the scene tree
		if is_inside_tree():
			if Engine.is_editor_hint():
				call_deferred("setup_visuals")
			var trigger = get_node_or_null("RepairTrigger")
			# Check property existence before writing to avoid runtime errors
			if trigger and "system_id" in trigger:
				trigger.system_id = value
				

@export var is_broken: bool = false:
	set(value):
		is_broken = value
		if is_inside_tree():
			if not Engine.is_editor_hint():
				GameState.set_system_broken(system_id, is_broken)
			call_deferred("_update_warning_light")

@export var camera_focus_point: Node3D:
	set(value):
		camera_focus_point = value
		if is_inside_tree():
			var trigger = get_node_or_null("RepairTrigger")
			if trigger and "camera_focus_point" in trigger:
				trigger.camera_focus_point = value

@export var progression_key: String = ""

func _ready() -> void:
	if not Engine.is_editor_hint():
		GameState.set_system_broken(system_id, is_broken)
	
	var trigger = get_node_or_null("RepairTrigger")
	if trigger:
		if "system_id" in trigger:
			trigger.system_id = system_id
		if "camera_focus_point" in trigger:
			trigger.camera_focus_point = camera_focus_point
		if "progression_key" in trigger:
			trigger.progression_key = progression_key
	
	setup_visuals()
	_update_warning_light()

func setup_visuals() -> void:
	if not is_inside_tree():
		return
	
	# Fetch all nodes dynamically for tool script stability
	var m_fallback = get_node_or_null("Column")
	var m_ballast = get_node_or_null("BallastModel")
	var m_boiler = get_node_or_null("BoilerModel")
	var m_sonar = get_node_or_null("SonarModel")
	var m_circuit = get_node_or_null("CircuitModel")
	
	if m_fallback: m_fallback.visible = false
	if m_ballast: m_ballast.visible = false
	if m_boiler: m_boiler.visible = false
	if m_sonar: m_sonar.visible = false
	if m_circuit: m_circuit.visible = false
	
	match system_id:
		"Ballast":
			if m_ballast: m_ballast.visible = true
		"Boiler":
			if m_boiler: m_boiler.visible = true
		"Sonar":
			if m_sonar: m_sonar.visible = true
		"Circuit":
			if m_circuit: m_circuit.visible = true
		_:
			if m_fallback: m_fallback.visible = true

func _update_warning_light() -> void:
	if not is_inside_tree():
		return
	
	var light = get_node_or_null("StatusLight")
	if not light:
		return
	
	var target_pos_node: Node3D = null
	
	# Assign the UI color and fetch the corresponding marker node
	match system_id:
		"Ballast":
			light.light_color = Color(0.494, 0.894, 0.329, 1.0)
			target_pos_node = get_node_or_null("BallastLightPos")
		"Boiler":
			light.light_color = Color(0.988, 0.42, 0.008, 1.0)
			target_pos_node = get_node_or_null("BoilerLightPos")
		"Sonar":
			light.light_color = Color(0.184, 0.651, 1.0, 1.0)
			target_pos_node = get_node_or_null("SonarLightPos")
		"Circuit":
			light.light_color = Color(1.0, 0.973, 0.035, 1.0)
			target_pos_node = get_node_or_null("CircuitLightPos")
		_:
			light.light_color = Color(1.0, 1.0, 1.0, 1.0)
			
	# Snap the light to the marker's local position
	if target_pos_node:
		light.position = target_pos_node.position
	
	if flash_tween and flash_tween.is_valid():
		flash_tween.kill()
	
	var bulb = light.get_node_or_null("BulbMesh/Bulb")
	var mat: StandardMaterial3D = null
	if bulb and bulb.material_override:
		mat = bulb.material_override as StandardMaterial3D
		# Apply the system color to both the base texture and the emission glow
		mat.albedo_color = light.light_color
		mat.emission = light.light_color
		
	if is_broken:
		light.visible = true
		light.light_energy = 3.0
		if mat:
			mat.emission_energy_multiplier = 3.0
		
		# set_parallel(true) forces tween instructions to run at the same time
		flash_tween = create_tween().set_loops().set_parallel(true)
		
		# Tween the alpha down
		flash_tween.tween_property(light, "light_energy", 0.0, 0.5)
		if mat:
			flash_tween.tween_property(mat, "emission_energy_multiplier", 0.0, 0.5)
		
		# Chain waits for the previous parallel block to finish, then tweens the alpha back up
		flash_tween.chain().tween_property(light, "light_energy", 3.0, 0.5)
		if mat:
			flash_tween.tween_property(mat, "emission_energy_multiplier", 3.0, 0.5)
	else:
		light.visible = false
		light.light_energy = 0.0
		if mat:
			mat.emission_energy_multiplier = 0.0
