class_name Interactable
extends Area3D

## Prompt text shown to player when in range (e.g., "Open", "Repair")
@export var prompt_message: String = "Interact"
@export var progression_key: String = ""

@export var on_interact_dialogue_key: String = ""


## Evaluates whether the player is currently allowed to interact with this object
## Override in child scripts (check locked/broken state)
func can_interact() -> bool:
	return true


## Executes the interaction logic.
## Override in child scripts to define custom behavior
func interact(_player: CharacterBody3D) -> void:
	if progression_key != "":
		var area_progression_system = get_tree().current_scene.get_node_or_null("%AreaProgressionSystem")
		if area_progression_system:
			area_progression_system.complete_unlock_key(progression_key)
		else:
			print("no named AreaProgressionSystem exists in main scene tree")
	if on_interact_dialogue_key != "":
		PopupUI.show_next_text(on_interact_dialogue_key)


## Helper to fetch the active prompt (e.g., returns "Locked" if can_interact is false).
func get_interaction_text() -> String:
	return prompt_message
