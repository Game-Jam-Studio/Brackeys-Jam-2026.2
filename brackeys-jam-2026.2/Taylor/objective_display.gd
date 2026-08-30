extends Control

@export var tier_1_art: Texture2D
@export var tier_2_art: Texture2D
@export var tier_3_art: Texture2D

@export var tier_1_theme: Theme
@export var tier_2_theme: Theme
@export var tier_3_theme: Theme

@onready var background_texture: TextureRect = $TextureRect
@onready var objective_label: Label = $Label


func _ready() -> void:
	ObjectiveManager.objective_updated.connect(_on_objective_updated)
	ObjectiveManager.objective_tier_changed.connect(_on_objective_tier_changed)
	ObjectiveManager.set_display_visible.connect(_on_set_display_visible)
	background_texture.texture = tier_1_art
	visible = false # Hide on launch


func _on_set_display_visible(is_visible: bool) -> void:
	visible = is_visible


func _on_objective_updated(new_text: String) -> void:
	objective_label.text = new_text


func _on_objective_tier_changed(tier: int) -> void:
	match tier:
		1:
			background_texture.texture = tier_1_art
		2:
			background_texture.texture = tier_2_art
		3:
			background_texture.texture = tier_3_art
