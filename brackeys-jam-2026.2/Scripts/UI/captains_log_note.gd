class_name CaptainsLogNote
extends Interactable

@export var line_id: String = ""

@onready var prompt_sprite: Sprite3D = $"CollisionShape3D/Key Prompt"

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	if prompt_sprite:
		prompt_sprite.visible = false

func interact(_player: CharacterBody3D) -> void:
	var captains_log = get_tree().current_scene.get_node_or_null("UI/CaptainsLog")
	if captains_log:
		captains_log.show_log(line_id)

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and prompt_sprite:
		prompt_sprite.visible = true

func _on_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D and prompt_sprite:
		prompt_sprite.visible = false
