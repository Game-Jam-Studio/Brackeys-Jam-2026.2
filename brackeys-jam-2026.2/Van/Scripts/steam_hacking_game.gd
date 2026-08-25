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
	%Gauge2/ValidArea.rotation = remap(gauge2_value, 0, 1, -deg_to_rad(dial_2.max_rotation), deg_to_rad(dial_2.max_rotation))
	%Gauge3/ValidArea.rotation = remap(gauge3_value, 0, 1, -deg_to_rad(dial_3.max_rotation), deg_to_rad(dial_3.max_rotation))
#Set initial needle rotation
	%Gauge1/Needle.rotation = deg_to_rad(15) * randi_range(-5, 5)
	%Gauge2/Needle.rotation = deg_to_rad(15) * randi_range(-5, 5)
	%Gauge3/Needle.rotation = deg_to_rad(15) * randi_range(-5, 5)
#Check if any needles are correct
	check_dial_1()
	check_dial_2()
	check_dial_3()


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
	%Gauge1/Needle.rotation = clamp(%Gauge1/Needle.rotation + value, -deg_to_rad(dial_1.max_rotation), deg_to_rad(dial_1.max_rotation))
	%Gauge2/Needle.rotation = clamp(%Gauge2/Needle.rotation + value, -deg_to_rad(dial_2.max_rotation), deg_to_rad(dial_2.max_rotation))
	check_dial_1()
	check_dial_2()

func _on_dial_2_value_changed(value: Variant) -> void:
	%Gauge2/Needle.rotation = clamp(%Gauge2/Needle.rotation + value, -deg_to_rad(dial_2.max_rotation), deg_to_rad(dial_2.max_rotation))
	%Gauge3/Needle.rotation = clamp(%Gauge3/Needle.rotation - value, -deg_to_rad(dial_3.max_rotation), deg_to_rad(dial_3.max_rotation))
	check_dial_2()
	check_dial_3()

func _on_dial_3_value_changed(value: Variant) -> void:
	%Gauge1/Needle.rotation = clamp(%Gauge1/Needle.rotation - value, -deg_to_rad(dial_1.max_rotation), deg_to_rad(dial_1.max_rotation))
	%Gauge3/Needle.rotation = clamp(%Gauge3/Needle.rotation + value, -deg_to_rad(dial_3.max_rotation), deg_to_rad(dial_3.max_rotation))
	check_dial_1()
	check_dial_3()

func check_dial_1():
	if snapped(%Gauge1/Needle.rotation, 0.1) == snapped(%Gauge1/ValidArea.rotation, 0.1):
		print("Dial1 Correct")
		gauge1_correct = true
	else:
		print("Dial1 Wrong")
		gauge1_correct = false

func check_dial_2():
	if snapped(%Gauge2/Needle.rotation, 0.1) == snapped(%Gauge2/ValidArea.rotation, 0.1):
		print("Dial2 Correct")
		gauge2_correct = true
	else:
		print("Dial2 Wrong")
		gauge2_correct = false

func check_dial_3():
	if snapped(%Gauge3/Needle.rotation, 0.1) == snapped(%Gauge3/ValidArea.rotation, 0.1):
		print("Dial3 Correct")
		gauge3_correct = true
	else:
		print("Dial3 Wrong")
		gauge3_correct = false
