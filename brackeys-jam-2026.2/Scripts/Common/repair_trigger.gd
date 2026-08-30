class_name RepairTrigger
extends Interactable

signal launch_minigame_requested(minigame_type: String, trigger: RepairTrigger)
signal station_repair_failed(system_id: String)
signal station_repair_succeeded(system_id: String)

# Defines where the camera interpolates to
@export var camera_focus_point: Node3D
@onready var station: Node = get_parent()
@onready var prompt_sprite: Sprite3D = $"Key Prompt"

@export var on_repair_end_dialogue_key: String = ""


func _ready() -> void:
	add_to_group("repair_triggers")
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	if prompt_sprite:
		prompt_sprite.visible = false


func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and prompt_sprite:
		prompt_sprite.visible = true


func _on_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D and prompt_sprite:
		prompt_sprite.visible = false


# minigames can always be interacted with but if they are already repaired
# it will just tell the user that
func can_interact() -> bool:
	return true


func interact(_player: CharacterBody3D) -> void:
	if prompt_sprite:
			prompt_sprite.visible = false
	
	if station.is_broken:
		# Mark the system as repaired to stop the global alarm and flashing lights
		station.is_broken = false
		GameState.set_system_broken(station.system_id, false)
		
		# Lock the system in GameState so the breakdown manager cannot target it again
		GameState.set_system_repairing(station.system_id, true)
		
		launch_minigame_requested.emit(station.system_id, self)
	else:
		PopupUI.launch_terminal("System operational.")
	super(_player)


func end_repair(success: bool) -> void:
	# Release the system lock so the breakdown manager can target it again
	GameState.set_system_repairing(station.system_id, false)
	
	#if on_repair_end_dialogue_key != "":
	#	PopupUI.show_next_text(on_repair_end_dialogue_key)
	
	if success:
		# System restored, no penalty taken
		PopupUI.launch_terminal("System stabilized.")
		station_repair_succeeded.emit(station.system_id)
	else:
		# Deduct flat penalty from subsystem's health
		GameState.apply_failure_penalty(station.system_id)
		PopupUI.launch_terminal("System damaged during repair attempt.")
		station_repair_failed.emit(station.system_id)
