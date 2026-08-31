class_name Interactable
extends Area3D


## Evaluates whether the player is currently allowed to interact with this object
## Override in child scripts (check locked/broken state)
func can_interact() -> bool:
	return true


## Executes the interaction logic.
## Override in child scripts to define custom behavior
func interact(_player: CharacterBody3D) -> void:
	pass
