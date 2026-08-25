extends TextureRect

signal value_set(value)
signal value_changed(value)
@onready var steam_hacking_game: Control = $"../../../../.."


var value: float = 0.5
var new_value: float = 0.5
var dragging: bool = false
var start_pos: Vector2
var current_rot: float
var freeze: bool = false

#Exposed variables
@export var max_rotation: float = 180
@export var notches: float = 24


func _ready() -> void:
#Make sure root node's random values are ready
	await steam_hacking_game.ready
#Tell root default dial values
	value_set.emit(value)


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
				#print(start_pos)
			else:
			#Mouse released
				dragging = false
				value_set.emit(snapped(value, 0.1))
			#Release Mouse
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				warp_mouse(start_pos)
				#print(value)
	elif event is InputEventMouseMotion and dragging and !freeze:
	#Handle Dial Rotation
		if new_value != value:
			value_changed.emit(value)
			new_value = value
			#print(new_value)
			play_dial_sound()
		current_rot = clampf(current_rot + deg_to_rad(event.screen_relative.x)/10, deg_to_rad(-max_rotation), deg_to_rad(max_rotation))
		rotation = snapped(current_rot, deg_to_rad(max_rotation / (notches / 2)))
		value = (snapped(remap(roundf(rad_to_deg(rotation)), -max_rotation, max_rotation, 0, 1), 0.01))
		

func play_dial_sound():
	%AudioStreamPlayer.pitch_scale = randf_range(0.975, 1.025)
	%AudioStreamPlayer.play()
