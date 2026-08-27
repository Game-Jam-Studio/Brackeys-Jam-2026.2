extends Node3D

var sceneTime: float = 0.0
var pulseTime: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	sceneTime += 0.1
	$Dark/MeshInstance3D.transparency = (sin(sceneTime/100) + 1) / 2 
 
