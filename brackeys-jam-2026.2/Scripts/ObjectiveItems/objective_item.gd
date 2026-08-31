class_name ObjectiveItem
extends Interactable

@export var unlock_key: String = "power_cell"

@onready var prompt_sprite: Sprite3D = $"CollisionShape3D/Key Prompt"

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	if prompt_sprite:
		prompt_sprite.visible = false

func interact(_player: CharacterBody3D) -> void:
	GameState.collect_item(unlock_key)
	queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and prompt_sprite:
		prompt_sprite.visible = true

func _on_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D and prompt_sprite:
		prompt_sprite.visible = false
