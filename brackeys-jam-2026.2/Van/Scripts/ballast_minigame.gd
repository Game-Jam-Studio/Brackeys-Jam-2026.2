extends Control
@onready var dial_1: TextureRect = %Dial1
@onready var dial_2: TextureRect = %Dial2
@onready var dial_3: TextureRect = %Dial3
const UI_ACCEPT = preload("uid://ci0u00xywksjx")
const UI_ERROR = preload("uid://44cjuy6hy1ge")

# Emitted on outcome so the caller can return the camera and call end_repair() on the trigger.
signal minigame_completed(success: bool)

var gauge1_value: float
var gauge2_value: float
var gauge3_value: float

var gauge1_correct: bool
var gauge2_correct: bool
var gauge3_correct: bool

# Adjust how much mouse movement is needed to move the dials.
# Values in the 30s-50s are reasonable, 100-200+ gets ridiculous.
@export var mouse_movement_threshold: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Dial1.mouse_movement_threshold = mouse_movement_threshold
	%Dial2.mouse_movement_threshold = mouse_movement_threshold
	%Dial3.mouse_movement_threshold = mouse_movement_threshold

	$AudioStreamPlayer.volume_linear = 0.4

# Get tier assets from ProgressionManager
	var gauge_texture = ProgressionManager.get_asset_texture("ballast", "gauge")
	var area_texture = ProgressionManager.get_asset_texture("ballast", "valid_area")
	var needle_texture = ProgressionManager.get_asset_texture("ballast", "needle")
	var dial_texture = ProgressionManager.get_asset_texture("ballast", "dial")

	# Apply Gauge textures
	%Gauge1.texture = gauge_texture
	%Gauge2.texture = gauge_texture
	%Gauge3.texture = gauge_texture

	# Apply ValidArea textures
	$UIRoot/HBoxContainer/VBoxContainer1/Gauge1/ValidArea/Area1.texture = area_texture
	$UIRoot/HBoxContainer/VBoxContainer2/Gauge2/ValidArea/Area1.texture = area_texture
	$UIRoot/HBoxContainer/VBoxContainer3/Gauge3/ValidArea/Area1.texture = area_texture

	# Apply Needle textures
	$UIRoot/HBoxContainer/VBoxContainer1/Gauge1/Needle/Needle1.texture = needle_texture
	$UIRoot/HBoxContainer/VBoxContainer2/Gauge2/Needle/Needle1.texture = needle_texture
	$UIRoot/HBoxContainer/VBoxContainer3/Gauge3/Needle/Needle1.texture = needle_texture

	# Apply Dial textures
	%Dial1.texture = dial_texture
	%Dial2.texture = dial_texture
	%Dial3.texture = dial_texture

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
		$Menu.visible = false
		%UIRoot.visible = false
		minigame_completed.emit(true)
		$AudioStreamPlayer.stream = UI_ACCEPT
		$AudioStreamPlayer.play()
		await get_tree().create_timer(1).timeout
		queue_free()
	else:
		%UIRoot.visible = false
		$Menu.visible = false
		dial_1.freeze = true
		dial_2.freeze = true
		dial_3.freeze = true
		minigame_completed.emit(false)
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
		gauge1_correct = true
	else:
		gauge1_correct = false

func check_dial_2():
	if snapped(%Gauge2/Needle.rotation, 0.1) == snapped(%Gauge2/ValidArea.rotation, 0.1):
		gauge2_correct = true
	else:
		gauge2_correct = false

func check_dial_3():
	if snapped(%Gauge3/Needle.rotation, 0.1) == snapped(%Gauge3/ValidArea.rotation, 0.1):
		gauge3_correct = true
	else:
		gauge3_correct = false
