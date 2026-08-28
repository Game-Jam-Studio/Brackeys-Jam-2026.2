extends Node2D

@export var key: Key = KEY_A
@export var noteTexture: Texture2D
@export var errorColor: Color = Color.RED
@export var successColor: Color = Color.GREEN
@export var normalColor: Color = Color.WHITE
@export var noteManager: NoteManager

@export var pitch_scale: float = 1.0
@export var sonarSound: AudioStream
@export var errorSound: AudioStream

@onready var label_node: Label = $Letter
@onready var texture_node = $Sprite2D

@export var label_text: String = "":
	set(value):
		label_text = value
		if is_node_ready() and label_node:
			label_node.text = value

var sfx_player: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sfx_player = get_parent().get_node("AudioStreamPlayer")
	$Sprite2D.texture = noteTexture
	if label_node and not label_text.is_empty():
		label_node.text = label_text


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == key:
			if $ValidArea2D.has_overlapping_areas():
				var overlappingNotes = $ValidArea2D.get_overlapping_areas()
				for note in overlappingNotes:
					note.get_parent().queue_free()
				sfx_player.stream = sonarSound
				sfx_player.pitch_scale = pitch_scale
				sfx_player.play()
				_flash_color(successColor)
			else:
				_on_error()

@onready var sprite_node: Sprite2D = $Sprite2D


func update_tier_presentation(tier: int) -> void:
	if label_node:
		label_node.theme = ProgressionManager.get_ai_theme(tier)
	
	if texture_node:
		texture_node.texture = ProgressionManager.get_asset_texture("sonar", "destination")
		var trans = ProgressionManager.get_destination_transform(tier)
		texture_node.position = trans["position"]
		texture_node.scale = trans["scale"]


func _flash_color(color: Color) -> void:
	$Sprite2D.modulate = color
	var tween = create_tween()
	tween.tween_property($Sprite2D, "modulate", normalColor, 0.25)

func _on_error() -> void:
	sfx_player.stream = errorSound
	sfx_player.pitch_scale = 1
	sfx_player.play()
	_flash_color(errorColor)
	noteManager.errorCount += 1

func _on_error_area_2d_area_entered(note: Area2D) -> void:
	note.get_parent().queue_free()
	_on_error()
