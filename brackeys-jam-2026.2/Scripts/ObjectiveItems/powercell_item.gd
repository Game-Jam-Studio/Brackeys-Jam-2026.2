extends Node3D 

@export var unlock_key: String = "power_cell"

func interact() -> void:
	AreaProgressionSystem.complete_unlock_key(unlock_key)
	
	# Remove the item from the scene after use
	queue_free()
