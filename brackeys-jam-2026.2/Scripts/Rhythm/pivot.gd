extends Node2D

# Full rotations per second (e.g. 0.5 = 1 full sweep every 2 seconds)
@export var sweeps_per_second: float = 0.3


func _process(delta: float) -> void:
	rotation += TAU * sweeps_per_second * delta
