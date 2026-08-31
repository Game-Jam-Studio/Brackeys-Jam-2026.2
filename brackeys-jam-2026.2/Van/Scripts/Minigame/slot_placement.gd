@tool
extends TextureRect


@warning_ignore("unused_parameter")
func _process(delta) -> void:
	if Engine.is_editor_hint():
		visible = true
		position = -get_size() / 2
	else:
		visible = false
