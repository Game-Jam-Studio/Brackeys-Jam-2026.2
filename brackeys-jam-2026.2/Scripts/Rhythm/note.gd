extends Node2D
class_name Note

@export var speed: float
@export var destination: Vector2
@export var initial_scale: Vector2 = Vector2(0, 0) # Starting size when spawned
@export var target_scale: Vector2 = Vector2(0.7, 0.7) # Full size at destination
@onready var sprite_node: Sprite2D = $Sprite2D

var direction: Vector2
var start_position: Vector2
var total_distance: float = 0.0


func initialize() -> void:
	var note_texture = ProgressionManager.get_asset_texture("sonar", "note")
	$Sprite2D.texture = note_texture
	
	#if note_texture and note_texture.resource_path.contains("corrupted"):
		#target_scale = Vector2(0.2, 0.2)
		#
	modulate.a = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_position = global_position
	total_distance = start_position.distance_to(destination)
	direction = global_position.direction_to(destination)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if destination != null:
		position += direction * speed * delta
		if total_distance > 0.0:
			var progress: float = clampf(1.0 - (position.distance_to(destination) / total_distance), 0.0, 1.0)
			scale = target_scale * progress
			
			# Fade alpha in smoothly
			modulate.a = progress
