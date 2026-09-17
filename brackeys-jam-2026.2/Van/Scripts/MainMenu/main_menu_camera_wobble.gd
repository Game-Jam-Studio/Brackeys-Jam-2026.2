extends Control

var start_rotation: float
var start_position: Vector2
var change: float
var speed: float = .25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_rotation = rotation
	start_position = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	change += delta
	position.y = start_position.y + sin(start_position.y + (change * (2 * speed))) * 10
	position.x = start_position.x + cos(start_position.y + (change * speed)) * 30
	rotation = cos(start_rotation + (change * speed) + 1.4) / 100
