class_name DoorTrigger
extends Interactable

## Controlled by the root Door script (can also be read directly)
var is_locked: bool = true

@export var is_open: bool = false
@export var open_angle_degrees: float = -90.0

## Duration of the opening animation in seconds
@export var open_duration: float = 0.6

@onready var hinge: Node3D = $"../Hinge"
@onready var trigger_shape: CollisionShape3D = $TriggerShape


func _ready() -> void:
	# If marked open at game start, snap rotation immediately
	if is_open:
		hinge.rotation_degrees.y = open_angle_degrees
		trigger_shape.set_deferred("disabled", true)


## Overrides base Interactable can_interact()
func can_interact() -> bool:
	return not is_locked and not is_open


## Overrides base Interactable interact()
func interact(_player: CharacterBody3D) -> void:
	if not is_open:
		open_door()


## Smoothly rotates the hinge and disables future interactions
func open_door() -> void:
	is_open = true
	trigger_shape.set_deferred("disabled", true)
	
	# Animate the AnimatableBody3D rotation smoothly
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(hinge, "rotation_degrees:y", open_angle_degrees, open_duration)

## Helper function to unlock the door externally
func unlock() -> void:
	is_locked = false
