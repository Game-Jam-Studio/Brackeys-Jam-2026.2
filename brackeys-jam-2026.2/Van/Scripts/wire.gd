extends TextureRect

var dragging: bool
var slotted: bool
var line_2d: Line2D
var wire_ID: int
var tick: float
const UI_DIAL_SHORT = preload("uid://f5we04nn8mkj")

func _ready() -> void:
	await $"../..".ready
	line_2d = Line2D.new()
	add_child(line_2d)
	line_2d.width = $"../..".wire_width
	line_2d.add_point(Vector2(position.x, position.y + (size.y / 2)), 0)
	line_2d.add_point(size / 2, 1)
	line_2d.reparent(get_parent())
	line_2d.global_position = Vector2.ZERO
	line_2d.set_point_position(1, Vector2(position.x + size.x / 2, position.y + size.y / 2))


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and !slotted:
		%AudioStreamPlayer.stream = UI_DIAL_SHORT
		%AudioStreamPlayer.pitch_scale = 1.5
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
			#Mouse held
				dragging = true
				Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
			else:
			#Mouse released
				dragging = false
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseMotion and dragging and !slotted:
		position += event.position - size / 2
		line_2d.set_point_position(1, position + size / 2)
		tick += clamp(event.screen_relative.length(), 0, 50)
		if tick > 200:
			%AudioStreamPlayer.play()
			tick = 0
