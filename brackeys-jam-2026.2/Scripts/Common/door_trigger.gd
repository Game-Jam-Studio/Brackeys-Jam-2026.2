class_name DoorTrigger
extends Interactable

## Controlled by the root Door script (can also be read directly)
var is_locked: bool = true

@export var on_door_open_dialogue_key: String = ""

@export var is_open: bool = false
@export var open_translation_amount: float = 2

## Duration of the opening animation in seconds
@export var open_duration: float = 0.6

@onready var hinge: Node3D = $"../Hinge"
@onready var trigger_shape: CollisionShape3D = $TriggerShape

@export var door_open_sound: AudioStream
@export var door_locked_sound: AudioStream

var sfx_player: AudioStreamPlayer3D


func _ready() -> void:
	sfx_player = get_parent().get_node("AudioStreamPlayer3D")
	# If marked open at game start, snap rotation immediately
	if is_open:
		hinge.rotation_degrees.y = open_translation_amount
		trigger_shape.set_deferred("disabled", true)


## Overrides base Interactable can_interact()
func can_interact() -> bool:
	return not is_open


## Overrides base Interactable interact()
func interact(_player: CharacterBody3D) -> void:
	if not is_locked and not is_open:
		sfx_player.stream = door_open_sound
		sfx_player.play()
		open_door()
	else:
		sfx_player.stream = door_locked_sound
		sfx_player.play()
	super(_player)


## Smoothly rotates the hinge and disables future interactions
func open_door() -> void:
	is_open = true
	trigger_shape.set_deferred("disabled", true)
	
	if on_door_open_dialogue_key != "":
		PopupUI.show_next_text(on_door_open_dialogue_key)
	
	# Animate the AnimatableBody3D rotation smoothly
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(hinge, "position", Vector3(open_translation_amount,0,0), open_duration)

## Helper function to unlock the door externally
func unlock() -> void:
	is_locked = false
