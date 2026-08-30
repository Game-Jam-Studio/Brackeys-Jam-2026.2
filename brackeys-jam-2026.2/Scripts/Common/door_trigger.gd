class_name DoorTrigger
extends Interactable

var is_locked: bool = true

@export var is_open: bool = false
@export var open_translation_amount: float = 1.5

## Duration of the opening animation in seconds
@export var open_duration: float = 0.6

@onready var hinge: Node3D = $"../Hinge"
@onready var trigger_shape: CollisionShape3D = $TriggerShape

@export var door_special_open_sound: AudioStream
@export var door_locked_sound: AudioStream

@onready var prompt_sprite: Sprite3D = $"Key Prompt"

# For deleting the Area1 Fog
@export var other_door_trigger: Node3D
@export var fog_node: Node3D
var fog_removed: bool = false

var sfx_player: AudioStreamPlayer3D


func _ready() -> void:
	sfx_player = get_parent().get_node("AudioStreamPlayer3D")
	
	if is_open:
		hinge.rotation_degrees.y = open_translation_amount
		trigger_shape.set_deferred("disabled", true)
	
	if prompt_sprite:
		prompt_sprite.visible = false


## Overrides base Interactable can_interact()
func can_interact() -> bool:
	return not is_open


## Overrides base Interactable interact()
func interact(_player: CharacterBody3D) -> void:
	var main_door = get_parent()
	if main_door and main_door.has_method("check_item_requirement"):
		if not main_door.check_item_requirement(_player):
			return
			
	super.interact(_player)
	
	if not is_locked and not is_open:
		sfx_player.stream = main_door.special_open_sound
	else:
		sfx_player.stream = door_special_open_sound
	
	sfx_player.play()
	sfx_player.pitch_scale = randf_range(0.7, 0.8)
	open_door()
	
	if prompt_sprite:
			prompt_sprite.queue_free()
	else:
		sfx_player.stream = door_locked_sound
		sfx_player.play()
	super(_player)
	
	if fog_node and is_instance_valid(fog_node):
		fog_node.queue_free()





## Opens door & disables future interactions
func open_door() -> void:
	is_open = true
	trigger_shape.set_deferred("disabled", true)
	
	# Slide the AnimatableBody3D smoothly
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(hinge, "position", Vector3(open_translation_amount,0,0), open_duration)

## Helper function to unlock the door externally
func unlock() -> void:
	is_locked = false


func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and prompt_sprite:
		prompt_sprite.visible = true


func _on_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D and prompt_sprite:
		prompt_sprite.visible = false
