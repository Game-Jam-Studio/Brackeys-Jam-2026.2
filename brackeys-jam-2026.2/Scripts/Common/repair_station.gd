class_name RepairStation
extends Node3D

@export_enum("Ballast", "Boiler", "Sonar", "Circuit") var system_id: String = "Ballast":
	set(value):
		system_id = value
		if is_node_ready() and repair_trigger:
			repair_trigger.system_id = value

@export var is_broken: bool = false:
	set(value):
		is_broken = value
		if is_inside_tree():
			GameState.set_system_broken(system_id, is_broken)

@export var camera_focus_point: Node3D:
	set(value):
		camera_focus_point = value
		if is_node_ready() and repair_trigger:
			repair_trigger.camera_focus_point = value

@export var progression_key: String = ""

@onready var repair_trigger: RepairTrigger = $RepairTrigger
@onready var mesh_node: MeshInstance3D = $Column

func _ready() -> void:
	# Register initial broken state with GameState on level load
	GameState.set_system_broken(system_id, is_broken)
	# Push initial Inspector values down to the inner trigger
	if repair_trigger and "camera_focus_point" in repair_trigger:
		repair_trigger.camera_focus_point = camera_focus_point
	
	$RepairTrigger.progression_key = progression_key
	apply_test_color()


func apply_test_color() -> void:
	if not mesh_node:
		return
		
	var mat := StandardMaterial3D.new()
	match system_id:
		"Ballast":
			mat.albedo_color = Color(0.494, 0.894, 0.329, 1.0)
		"Boiler":
			mat.albedo_color = Color(0.988, 0.42, 0.008, 1.0)
		"Sonar":
			mat.albedo_color = Color(0.184, 0.651, 1.0, 1.0)
		"Circuit":
			mat.albedo_color = Color(1.0, 0.973, 0.035, 1.0)
		_:
			mat.albedo_color = Color(1.0, 1.0, 1.0, 1.0)
			
	mesh_node.material_override = mat
