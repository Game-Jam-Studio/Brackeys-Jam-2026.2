extends Camera3D

var start_rotation: Vector3
var change: float
var speed: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_rotation = rotation


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	change += delta
	rotation.x = start_rotation.x + sin(start_rotation.x + (change * (2 * speed))) / 250
	rotation.y = start_rotation.y + cos(start_rotation.x + (change * speed)) / 125
	rotation.z = cos(start_rotation.z + (change * speed) + 0.4) / 125
