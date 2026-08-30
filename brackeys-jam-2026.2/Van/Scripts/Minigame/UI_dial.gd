extends TextureRect

signal value_changed(value)
@onready var ballast_minigame: Control = $"../../../../.."


var value: float
var new_value: float = 0.5
var dragging: bool = false
var start_pos: Vector2
var current_rot: float
var freeze: bool = false
var mouse_movement_threshold: float

#Exposed variables
@export var max_rotation: float = 180
@export var notches: float = 24


func _ready() -> void:
#Make sure root node's random values are ready
	await ballast_minigame.ready


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and !freeze:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
			#Mouse held
				dragging = true
			#Store starting mouse position
				start_pos = get_local_mouse_position()
			#Capture mouse
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			else:
			#Mouse released
				dragging = false
			#Release Mouse
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				warp_mouse(start_pos)
	elif event is InputEventMouseMotion and dragging and !freeze:
	
	#Handle Dial Rotation
		if value > 0.5:
			rotation += deg_to_rad(15)
			new_value = deg_to_rad(15)
			value_changed.emit(new_value)
			value = 0
			play_dial_sound()
		elif value < -0.5:
			rotation -= deg_to_rad(15)
			new_value = deg_to_rad(-15)
			value_changed.emit(new_value)
			value = 0
			play_dial_sound()
		if event.screen_relative.x > mouse_movement_threshold:
			value += 0.025
		elif event.screen_relative.x < -mouse_movement_threshold:
			value -= 0.025

func play_dial_sound():
	%AudioStreamPlayer.pitch_scale = randf_range(0.975, 1.025)
	%AudioStreamPlayer.play()
