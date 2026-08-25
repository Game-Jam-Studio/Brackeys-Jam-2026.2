class_name RhythmMinigame
extends Control

# Emitted on outcome so the caller can return the camera and call end_repair() on the trigger.
signal minigame_completed(success: bool)

@onready var note_manager: NoteManager = $NoteManager


func _ready() -> void:
	if note_manager:
		note_manager.minigame_completed.connect(_on_note_manager_completed)


func _on_note_manager_completed(success: bool) -> void:
	minigame_completed.emit(success)
	queue_free()
