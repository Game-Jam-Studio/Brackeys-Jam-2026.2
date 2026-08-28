class_name SonarMinigame
extends Control

# Emitted on outcome so the caller can return the camera and call end_repair() on the trigger.
signal minigame_completed(success: bool)

@onready var note_manager: NoteManager = $NoteManager
@onready var circle_node: Sprite2D = $Circle
@onready var cone_node: Sprite2D = $Pivot/Cone

# debug for testing
@export_range(0, 3) var debug_force_tier: int = 0 # Set to 3 to test corrupted art, 0 for normal gameplay

func _ready() -> void:
	if note_manager:
		note_manager.minigame_completed.connect(_on_note_manager_completed)
	
	if circle_node:
		circle_node.texture = ProgressionManager.get_asset_texture("sonar", "circle")
	if cone_node:
		cone_node.texture = ProgressionManager.get_asset_texture("sonar", "cone")

func _on_note_manager_completed(success: bool) -> void:
	minigame_completed.emit(success)
	queue_free()
