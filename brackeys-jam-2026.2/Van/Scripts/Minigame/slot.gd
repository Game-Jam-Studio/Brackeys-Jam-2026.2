extends TextureRect

var slotted: bool
var slot_ID: int
signal wire_connected(wire_ID: int, slot_ID: int)
const UI_DIAL = preload("uid://bgkircabxx6ma")

func _ready() -> void:
	await $"../..".ready


func _on_area_2d_area_entered(wire: Area2D) -> void:
	if wire.get_parent().is_in_group("wires") and !slotted and !wire.get_parent().slotted:
		wire.get_parent().slotted = true
		wire.get_parent().position = position
		wire.get_parent().line_2d.set_point_position(0, position + size / 2)
		slotted = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		wire_connected.emit(wire.get_parent().wire_ID, slot_ID)
		%AudioStreamPlayer.stream = UI_DIAL
		%AudioStreamPlayer.pitch_scale = 1.0
		%AudioStreamPlayer.play()
