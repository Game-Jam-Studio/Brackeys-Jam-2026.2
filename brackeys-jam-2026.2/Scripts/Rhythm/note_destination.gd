extends Node2D

@export var key: Key = KEY_A
@export var noteTexture: Texture2D
@export var errorColor: Color = Color.RED
@export var successColor: Color = Color.GREEN
@export var normalColor: Color = Color.WHITE
@export var noteManager: NoteManager


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.texture = noteTexture

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == key:
			if $ValidArea2D.has_overlapping_areas():
				var overlappingNotes = $ValidArea2D.get_overlapping_areas()
				for note in overlappingNotes:
					note.get_parent().queue_free()
				_flash_color(successColor)
			else:
				_flash_color(errorColor)
				noteManager.errorCount += 1

func _flash_color(color: Color) -> void:
	$Sprite2D.modulate = color
	var tween = create_tween()
	tween.tween_property($Sprite2D, "modulate", normalColor, 0.25)


func _on_error_area_2d_area_entered(note: Area2D) -> void:
	note.get_parent().queue_free()
	_flash_color(errorColor)
	noteManager.errorCount += 1
