class_name Door
extends Node3D

@export_enum("Basic", "Mechanical", "Old", "Mouth") var door_variant: int = 0
@export var mesh_basic: Node3D
@export var mesh_mechanical: Node3D
@export var mesh_old: Node3D
@export var mesh_mouth: Node3D

@export var required_item_name: String = ""
@export var special_open_sound: AudioStream

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
	_update_variants()


func _update_variants() -> void:
	if mesh_basic: mesh_basic.visible = (door_variant == 0)
	if mesh_mechanical: mesh_mechanical.visible = (door_variant == 1)
	if mesh_old: mesh_old.visible = (door_variant == 2)
	if mesh_mouth: mesh_mouth.visible = (door_variant == 2)


## Public helper to unlock the door externally
func unlock() -> void:
	is_locked = false
	door_trigger.unlock()


func check_item_requirement(player: Node3D) -> bool:
	if required_item_name != "" and player.has_method("has_item"):
		if not player.has_item(required_item_name):
			print("Missing required item: ", required_item_name)
			return false
	return true
