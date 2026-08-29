@tool
class_name RepairStation
extends Node3D

@export_enum("Ballast", "Boiler", "Sonar", "Circuit") var system_id: String = "Ballast":
	set(value):
		system_id = value
		if Engine.is_editor_hint():
			call_deferred("setup_visuals")
		
		# Fetch node dynamically instead of relying on @onready
		var trigger = get_node_or_null("RepairTrigger")
		if trigger:
			trigger.system_id = value

@export var is_broken: bool = false:
	set(value):
		is_broken = value
		if is_inside_tree() and not Engine.is_editor_hint():
			GameState.set_system_broken(system_id, is_broken)

@export var camera_focus_point: Node3D:
	set(value):
		camera_focus_point = value
		var trigger = get_node_or_null("RepairTrigger")
		if trigger and "camera_focus_point" in trigger:
			trigger.camera_focus_point = value

@export var progression_key: String = ""

func _ready() -> void:
	if not Engine.is_editor_hint():
		GameState.set_system_broken(system_id, is_broken)
	
	var trigger = get_node_or_null("RepairTrigger")
	if trigger:
		if "camera_focus_point" in trigger:
			trigger.camera_focus_point = camera_focus_point
		trigger.progression_key = progression_key
	
	setup_visuals()

func setup_visuals() -> void:
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
