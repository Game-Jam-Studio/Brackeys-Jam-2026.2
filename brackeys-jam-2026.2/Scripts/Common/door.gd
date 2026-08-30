class_name Door
extends Node3D

@export var is_locked: bool = true:
	set(value):
		is_locked = value
		# Syncs value down to the trigger if the node is already initialized
		if is_node_ready() and door_trigger:
			door_trigger.is_locked = value

## Reference to the inner trigger area
@onready var door_trigger: DoorTrigger = $DoorTrigger


func _ready() -> void:
	# Push the root export value down to the trigger on startup
	door_trigger.is_locked = is_locked


## Public helper to unlock the door externally
func unlock() -> void:
	is_locked = false
	door_trigger.unlock()
