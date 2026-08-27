extends TextureRect

var dragging: bool
var slotted: bool
var line_2d: Line2D

func _ready() -> void:
	await get_tree().current_scene.ready
	line_2d = Line2D.new()
	add_child(line_2d)
	line_2d.add_point(Vector2(position.x, position.y + (size.y / 2)), 0)
	line_2d.add_point(size / 2, 1)
	line_2d.reparent(get_parent())
	line_2d.global_position = Vector2.ZERO
	line_2d.set_point_position(1, Vector2(position.x + size.x / 2, position.y + size.y / 2))


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and !slotted:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
			#Mouse held
				dragging = true
			else:
			#Mouse released
				dragging = false
	elif event is InputEventMouseMotion and dragging and !slotted:
		position += event.position - size / 2
		line_2d.set_point_position(1, position + size / 2)
