class_name Interactable
extends Area3D

## Prompt text shown to player when in range (e.g., "Open", "Repair")
@export var prompt_message: String = "Interact"


## Evaluates whether the player is currently allowed to interact with this object
## Override in child scripts (check locked/broken state)
func can_interact() -> bool:
	return true


## Executes the interaction logic.
## Override in child scripts to define custom behavior
func interact(_player: CharacterBody3D) -> void:
	pass


## Helper to fetch the active prompt (e.g., returns "Locked" if can_interact is false).
func get_interaction_text() -> String:
	return prompt_message
