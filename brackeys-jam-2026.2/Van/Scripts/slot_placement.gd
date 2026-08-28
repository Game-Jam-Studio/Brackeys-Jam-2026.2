@tool
extends TextureRect


func _process(float) -> void:
	if Engine.is_editor_hint():
		visible = true
		position = -get_size() / 2
	else:
		visible = false
