class_name ControlTerminalTrigger
extends Interactable

# Signal emitted to level.gd to orchestrate the interaction
signal terminal_requested(trigger: ControlTerminalTrigger)

@export var camera_focus_point: Marker3D
@export var terminal_ui: Node

@onready var prompt_sprite: Sprite3D = $"Key Prompt"

func _ready() -> void:
	# Add to a unique group so level.gd can find and connect to it
	add_to_group("terminal_triggers")
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	if prompt_sprite:
		prompt_sprite.visible = false

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and prompt_sprite:
		prompt_sprite.visible = true

func _on_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D and prompt_sprite:
		prompt_sprite.visible = false

func interact(_player: CharacterBody3D) -> void:
	if prompt_sprite:
		prompt_sprite.visible = false
	
	# Notify level.gd to lock the player and transition the camera
	terminal_requested.emit(self)
	
	super(_player)
