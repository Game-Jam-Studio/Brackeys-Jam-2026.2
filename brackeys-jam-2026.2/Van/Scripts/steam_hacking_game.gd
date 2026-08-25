extends Control
@onready var dial_1: TextureRect = $Controls/Dial1
@onready var dial_2: TextureRect = $Controls/Dial2
@onready var dial_3: TextureRect = $Controls/Dial3
@onready var gauge_1_display: Control = $Gauge1
@onready var gauge_2_display: Control = $Gauge2
@onready var gauge_3_display: Control = $Gauge3

var gauge_1: float
var gauge_2: float
var gauge_3: float
var gauge_1_correct: bool
var gauge_2_correct: bool
var gauge_3_correct: bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#Set random values
	gauge_1 = snapped(randf_range(0, 1), 0.1)
	gauge_2 = snapped(randf_range(0, 1), 0.1)
	gauge_3 = snapped(randf_range(0, 1), 0.1)
#Set goal gauge rotation
	$Gauge1/Housing/ValidArea.rotation = remap(gauge_1, 0, 1, -deg_to_rad(dial_1.max_rotation), deg_to_rad(dial_1.max_rotation))
	$Gauge2/Housing/ValidArea.rotation = remap(gauge_2, 0, 1, -deg_to_rad(dial_1.max_rotation), deg_to_rad(dial_1.max_rotation))
	$Gauge3/Housing/ValidArea.rotation = remap(gauge_3, 0, 1, -deg_to_rad(dial_1.max_rotation), deg_to_rad(dial_1.max_rotation))
	#print("Dial 1 ", gauge_1)
	#print("Dial 2 ", gauge_2)
	#print("Dial 3 ", gauge_3)

func _on_dial_1_value_set(value: Variant) -> void:
	if value == gauge_1:
		#print("Dial1 Correct")
		dial_1.freeze = true
		gauge_1_correct = true
	else:
		#print("Dial1 Wrong")
		gauge_1_correct = false

func _on_dial_2_value_set(value: Variant) -> void:
	if value == gauge_2:
		#print("Dial2 Correct")
		dial_2.freeze = true
		gauge_2_correct = true
	else:
		#print("Dial2 Wrong")
		gauge_2_correct = false

func _on_dial_3_value_set(value: Variant) -> void:
	if value == gauge_3:
		#print("Dial3 Correct")
		dial_3.freeze = true
		gauge_3_correct = true
	else:
		#print("Dial3 Wrong")
		gauge_3_correct = false

#Player submits their answer
func _on_accept_button_down() -> void:
	if gauge_1_correct and gauge_2_correct and gauge_3_correct:
		$"Conditions/Success".visible = true
		$Controls.visible = false
		$Menu/Accept.visible = false
		$Gauge1.visible = false
		$Gauge2.visible = false
		$Gauge3.visible = false
	#Win signal goes here
		print("YOU WIN!")
		await get_tree().create_timer(2).timeout
		queue_free()
	else:
		$"Conditions/Failure".visible = true
		$Controls.visible = false
		$Menu/Accept.visible = false
		$Gauge1.visible = false
		$Gauge2.visible = false
		$Gauge3.visible = false
		dial_1.freeze = true
		dial_2.freeze = true
		dial_3.freeze = true
	#Lose signal goes here
		print("YOU LOSE!")
		await get_tree().create_timer(2).timeout
		queue_free()

func _on_dial_1_value_changed(value: Variant) -> void:
	$Gauge1/Housing/Needle.rotation = remap(value, 0, 1, -deg_to_rad(dial_1.max_rotation), deg_to_rad(dial_1.max_rotation))

func _on_dial_2_value_changed(value: Variant) -> void:
	$Gauge2/Housing/Needle.rotation = remap(value, 0, 1, -deg_to_rad(dial_1.max_rotation), deg_to_rad(dial_1.max_rotation))

func _on_dial_3_value_changed(value: Variant) -> void:
	$Gauge3/Housing/Needle.rotation = remap(value, 0, 1, -deg_to_rad(dial_1.max_rotation), deg_to_rad(dial_1.max_rotation))
