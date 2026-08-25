extends Control
@onready var dial_1: TextureRect = %Dial1
@onready var dial_2: TextureRect = %Dial2
@onready var dial_3: TextureRect = %Dial3
const UI_ACCEPT = preload("uid://ci0u00xywksjx")
const UI_ERROR = preload("uid://44cjuy6hy1ge")

var gauge1_value: float
var gauge2_value: float
var gauge3_value: float

var gauge1_correct: bool
var gauge2_correct: bool
var gauge3_correct: bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer.volume_linear = 0.4
#Set random values
	gauge1_value = snapped(randf_range(0, 1), 0.1)
	gauge2_value = snapped(randf_range(0, 1), 0.1)
	gauge3_value = snapped(randf_range(0, 1), 0.1)
#Set goal gauge rotation
	%Gauge1/ValidArea.rotation = remap(gauge1_value, 0, 1, -deg_to_rad(dial_1.max_rotation), deg_to_rad(dial_1.max_rotation))
	%Gauge2/ValidArea.rotation = remap(gauge2_value, 0, 1, -deg_to_rad(dial_1.max_rotation), deg_to_rad(dial_1.max_rotation))
	%Gauge3/ValidArea.rotation = remap(gauge3_value, 0, 1, -deg_to_rad(dial_1.max_rotation), deg_to_rad(dial_1.max_rotation))
	#print("Dial 1 ", gauge1_value)
	#print("Dial 2 ", gauge2_value)
	#print("Dial 3 ", gauge_3)

func _on_dial_1_value_set(value: Variant) -> void:
	if value == gauge1_value:
		#print("Dial1 Correct")
		dial_1.freeze = true
		gauge1_correct = true
	else:
		#print("Dial1 Wrong")
		gauge1_correct = false

func _on_dial_2_value_set(value: Variant) -> void:
	if value == gauge2_value:
		#print("Dial2 Correct")
		dial_2.freeze = true
		gauge2_correct = true
	else:
		#print("Dial2 Wrong")
		gauge2_correct = false

func _on_dial_3_value_set(value: Variant) -> void:
	if value == gauge3_value:
		#print("Dial3 Correct")
		dial_3.freeze = true
		gauge3_correct = true
	else:
		#print("Dial3 Wrong")
		gauge3_correct = false

#Player submits their answer
func _on_accept_button_down() -> void:
	$AudioStreamPlayer.pitch_scale = 1.0
	$AudioStreamPlayer.volume_linear = 1.0
	if gauge1_correct and gauge2_correct and gauge3_correct:
		$"Conditions/Success".visible = true
		$Menu.visible = false
		%UIRoot.visible = false
	#Win signal goes here
		print("YOU WIN!")
		$AudioStreamPlayer.stream = UI_ACCEPT
		$AudioStreamPlayer.play()
		await get_tree().create_timer(1).timeout
		queue_free()
	else:
		$"Conditions/Failure".visible = true
		%UIRoot.visible = false
		$Menu.visible = false
		dial_1.freeze = true
		dial_2.freeze = true
		dial_3.freeze = true
	#Lose signal goes here
		print("YOU LOSE!")
		$AudioStreamPlayer.stream = UI_ERROR
		$AudioStreamPlayer.play()
		await get_tree().create_timer(1).timeout
		queue_free()

func _on_dial_1_value_changed(value: Variant) -> void:
	%Gauge1/Needle.rotation = remap(value, 0, 1, -deg_to_rad(dial_1.max_rotation), deg_to_rad(dial_1.max_rotation))

func _on_dial_2_value_changed(value: Variant) -> void:
	%Gauge2/Needle.rotation = remap(value, 0, 1, -deg_to_rad(dial_1.max_rotation), deg_to_rad(dial_1.max_rotation))

func _on_dial_3_value_changed(value: Variant) -> void:
	%Gauge3/Needle.rotation = remap(value, 0, 1, -deg_to_rad(dial_1.max_rotation), deg_to_rad(dial_1.max_rotation))
