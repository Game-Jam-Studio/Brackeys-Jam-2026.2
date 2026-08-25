class_name RepairTrigger
extends Interactable

signal launch_minigame_requested(minigame_type: String, trigger: RepairTrigger)
signal station_repair_failed(system_id: String)
signal station_repair_succeeded(system_id: String)

# Defaults to "Pressure" fallback
@export_enum("Pressure", "Steam", "Rhythm") var system_id: String = "Pressure"
@export var is_broken: bool = false

# Defines where the camera interpolates to
@export var camera_focus_point: Node3D


func _ready() -> void:
	add_to_group("repair_triggers")


func can_interact() -> bool:
	return is_broken


func interact(_player: CharacterBody3D) -> void:
	if is_broken:
		launch_minigame_requested.emit(system_id, self)


func end_repair(success: bool) -> void:
	is_broken = false
	if success:
		station_repair_succeeded.emit(system_id)
	else:
		station_repair_failed.emit(system_id)
