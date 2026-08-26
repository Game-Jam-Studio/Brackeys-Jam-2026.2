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


# minigames can always be interacted with but if they are already repaired
# it will just tell the user that
func can_interact() -> bool:
	return true


func interact(_player: CharacterBody3D) -> void:
	if is_broken:
		# TerminalUI.launch_terminal("System in need of repair.")
		launch_minigame_requested.emit(system_id, self)
	else:
		TerminalUI.launch_terminal("System operational.")


func end_repair(success: bool) -> void:
	# we are leaving the state as repaired even if the player
	# fails the minigame to not allow retries
	is_broken = false
	if success:
		TerminalUI.launch_terminal("System back to full operational capacity.")
		station_repair_succeeded.emit(system_id)
	else:
		TerminalUI.launch_terminal("System degraded further, no repair action available.")
		station_repair_failed.emit(system_id)
