extends Node2D

@export var noteTextures: Array[Texture2D]
@export var speed: float
@export var destination: Vector2

func initialize(note: int) -> void:
	$Sprite2D.texture = noteTextures[note]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$Sprite2D.texture = noteTexture
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if destination != null:
		position = position.move_toward(destination, speed * delta)
	pass
