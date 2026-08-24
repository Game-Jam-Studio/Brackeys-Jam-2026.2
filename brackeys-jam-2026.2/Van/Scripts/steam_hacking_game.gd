extends Control
@onready var dial1: TextureRect = $Control/TextureRect
var gauge1: float
var gauge2: float
var gauge3: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gauge1 = snapped(randf_range(0, 1), 0.1)
	gauge2 = snapped(randf_range(0, 1), 0.1)
	gauge3 = snapped(randf_range(0, 1), 0.1)
	print(gauge1)
	print(gauge2)
	print(gauge3)


func _on_dial_1_value_changed(value: Variant) -> void:
	if value == gauge1:
		print("Dial1 Correct")
	else:
		print("Dial1 Wrong")


func _on_dial_2_value_changed(value: Variant) -> void:
	if value == gauge2:
		print("Dial2 Correct")
	else:
		print("Dial2 Wrong")

func _on_dial_3_value_changed(value: Variant) -> void:
	if value == gauge3:
		print("Dial3 Correct")
	else:
		print("Dial3 Wrong")
