class_name SonarMinigame
extends Control

# Emitted on outcome so the caller can return the camera and call end_repair() on the trigger.
signal minigame_completed(success: bool)

@onready var note_manager: NoteManager = $NoteManager
@onready var circle_node: Sprite2D = $Circle
@onready var cone_node: Sprite2D = $Pivot/Cone
@export var base_cone_texture: Texture2D
@onready var cone: Sprite2D = $Pivot/Cone


func _ready() -> void:
	#var current_texture = ProgressionManager.get_asset_texture("sonar", "cone")
	#cone.texture = current_texture
	#if current_texture == base_cone_texture:
	#	cone.modulate = Color("87ff55af")
	#else:
	#	cone.modulate = Color("ffffff")
	
	if note_manager:
		note_manager.minigame_completed.connect(_on_note_manager_completed)
	
	if circle_node:
		circle_node.texture = ProgressionManager.get_asset_texture("sonar", "circle")
	if cone_node:
		cone_node.texture = ProgressionManager.get_asset_texture("sonar", "cone")





func _on_note_manager_completed(success: bool) -> void:
	minigame_completed.emit(success)
	queue_free()
