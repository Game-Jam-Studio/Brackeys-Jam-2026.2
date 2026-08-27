extends TextureRect

var slotted: bool

func _ready() -> void:
	await get_tree().current_scene.ready

func _on_area_2d_area_entered(wire: Area2D) -> void:
	if wire.get_parent().is_in_group("wires") and !slotted:
		wire.get_parent().slotted = true
		wire.get_parent().position = position
		wire.get_parent().line_2d.set_point_position(1, position + size / 2)
		slotted = true
	pass
