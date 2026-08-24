extends TextureRect

signal value_changed(value)
@onready var steam_hacking_game: Control = $"../.."

var value: float = 0.5
var dragging: bool = false
var start_pos: Vector2
var current_rot: float
@export var max_rotation: float = 180
@export var notches: float = 24


func _ready() -> void:
	await steam_hacking_game.ready
	value_changed.emit(value)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				start_pos = get_local_mouse_position()
				dragging = true
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				#print(start_pos)
			else:
				dragging = false
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				warp_mouse(start_pos)
				value_changed.emit(value)
	elif event is InputEventMouseMotion and dragging:
		current_rot = clampf(current_rot + deg_to_rad(event.screen_relative.x)/10, deg_to_rad(-max_rotation), deg_to_rad(max_rotation))
		rotation = snapped(current_rot, deg_to_rad(max_rotation / (notches / 2)))
		value = (snapped(remap(roundf(rad_to_deg(rotation)), -max_rotation, max_rotation, 0, 1), 0.01))
