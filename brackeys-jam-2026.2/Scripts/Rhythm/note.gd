extends Node2D


@export var noteTextures: Array[Texture2D]
@export var speed: float
@export var destination: Vector2
@export var initial_scale: Vector2 = Vector2(0, 0) # Starting size when spawned
@export var target_scale: Vector2 = Vector2(0.6, 0.6) # Full size at destination


var direction: Vector2
var start_position: Vector2
var total_distance: float = 0.0


func initialize(note: int) -> void:
	$Sprite2D.texture = noteTextures[note]
	# Start completely transparent when spawned #
	modulate.a = 0.0 #


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_position = position
	total_distance = start_position.distance_to(destination)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if destination != null:
		position = position.move_toward(destination, speed * delta)
		if total_distance > 0.0:
			var progress: float = clampf(1.0 - (position.distance_to(destination) / total_distance), 0.0, 1.0)
			scale = Vector2.ONE * progress 
			
			# Fade alpha in smoothly
			modulate.a = progress
