class_name DoorTrigger
extends Interactable

# door_trigger handles logic for the door being interacted with

var is_locked: bool = true

@export var is_open: bool = false
@export var open_translation_amount: float = 1.5

## Duration of the opening animation in seconds
@export var open_duration: float = 0.6

@onready var hinge: Node3D = $"../Hinge"
@onready var trigger_shape: CollisionShape3D = $TriggerShape

@export var door_open_sound: AudioStream
@export var door_locked_sound: AudioStream

@onready var prompt_sprite: Sprite3D = $"Key Prompt"

var fog_node: Node3D

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


	# If door is unlocked, just open it
	# If door is locked & player doesn't have required item, play locked sound, do nothing
	# If door is locked & player has required item, consume item, call complete_unlock_key (which unlocks all doors and handles progression)
func interact(_player: CharacterBody3D) -> void:
	var main_door = get_parent()
	
	if is_locked:
		# Check if this door requires an item
		if main_door and main_door.has_method("check_item_requirement"):
			if not main_door.check_item_requirement(_player):
				# Play locked sound, do nothing
				sfx_player.stream = door_locked_sound
				sfx_player.play()
				return
		
		# If door has an item requirement, trigger area progression
		if main_door and main_door.required_item_name != "":
			var area_progression = get_tree().current_scene.get_node_or_null("AreaProgressionSystem")
			if area_progression:
				area_progression.complete_unlock_key(main_door.required_item_name, main_door)
			return
		else:
			# Locked door with no item requirement — do not open
			sfx_player.stream = door_locked_sound
			sfx_player.play()
			return
	
	# Door is unlocked, open it directly
	if not is_open:
		if main_door and "custom_open_sound" in main_door and main_door.custom_open_sound:
			sfx_player.stream = main_door.custom_open_sound
		else:
			sfx_player.stream = door_open_sound
		sfx_player.play()
		sfx_player.pitch_scale = randf_range(0.7, 0.8)
		open_door()
		if prompt_sprite:
			prompt_sprite.queue_free()
	else:
		sfx_player.stream = door_locked_sound
		sfx_player.play()


## Opens door & disables future interactions
## Opens door & disables future interactions
func open_door() -> void:
	is_open = true
	trigger_shape.set_deferred("disabled", true)
	
	# Remove fog of war for the room this door leads into
	if fog_node and is_instance_valid(fog_node):
		fog_node.queue_free()
		fog_node = null  # Prevent duplicate removal attempts
	
	# Unlock any doors associated with this room
	var main_door = get_parent()
	if main_door and "doors_to_unlock_on_open" in main_door:
		for door in main_door.doors_to_unlock_on_open:
			door.unlock()
	
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
