class_name SonarMinigame
extends Control

# Emitted on outcome so the caller can return the camera and call end_repair() on the trigger.
signal minigame_completed(success: bool)

@onready var note_manager: NoteManager = $NoteManager
@onready var circle_node: Sprite2D = $Circle
@onready var cone_node: Sprite2D = $Pivot/Cone
@export var base_cone_texture: Texture2D


func _ready() -> void:
	if note_manager:
		note_manager.minigame_completed.connect(_on_note_manager_completed)
	if circle_node:
		circle_node.texture = ProgressionManager.get_asset_texture("sonar", "circle")
	if cone_node:
		var current_texture = ProgressionManager.get_asset_texture("sonar", "cone")
		print("Loaded cone texture path: ", current_texture.resource_path if current_texture else "null")
		cone_node.texture = current_texture


func _on_note_manager_completed(success: bool) -> void:
	minigame_completed.emit(success)
	queue_free()
