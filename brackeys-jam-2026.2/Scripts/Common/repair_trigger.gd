class_name RepairTrigger
extends Interactable

signal launch_minigame_requested(minigame_type: String, trigger: RepairTrigger)
signal station_repair_failed(system_id: String)
signal station_repair_succeeded(system_id: String)

# Defines where the camera interpolates to
@export var camera_focus_point: Node3D
@onready var station: Node = get_parent()
@onready var prompt_sprite: Sprite3D = $"Key Prompt"


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
		station.is_broken = false
		GameState.set_system_broken(station.system_id, false)
		launch_minigame_requested.emit(station.system_id, self)
	else:
		PopupUI.launch_terminal("System operational.")
	super(_player)


func end_repair(success: bool) -> void:
	# we are leaving the state as repaired even if the player
	# fails the minigame to not allow retries
	station.is_broken = false
	if success:
		# System secured, no penalty taken
		PopupUI.launch_terminal("System stabilized.")
		station_repair_succeeded.emit(station.system_id)
	else:
		# Deduct flat penalty from subsystem's health
		GameState.apply_failure_penalty(station.system_id)
		PopupUI.launch_terminal("System damaged during repair attempt.")
		station_repair_failed.emit(station.system_id)
