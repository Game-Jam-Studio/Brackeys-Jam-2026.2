class_name RepairStation
extends Node3D

@export_enum("Pressure", "Steam", "Rhythm") var system_id: String = "Pressure":
	set(value):
		system_id = value
		if is_node_ready() and repair_trigger:
			repair_trigger.system_id = value

@export var is_broken: bool = false:
	set(value):
		is_broken = value
		if is_node_ready() and repair_trigger:
			repair_trigger.is_broken = value

@export var camera_focus_point: Node3D:
	set(value):
		camera_focus_point = value
		if is_node_ready() and repair_trigger:
			repair_trigger.camera_focus_point = value

@onready var repair_trigger: RepairTrigger = $RepairTrigger


func _ready() -> void:
	# Push initial Inspector values down to the inner trigger
	if repair_trigger:
		repair_trigger.system_id = system_id
		repair_trigger.is_broken = is_broken
		repair_trigger.camera_focus_point = camera_focus_point
