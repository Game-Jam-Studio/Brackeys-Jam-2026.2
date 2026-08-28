@tool
extends TextureRect


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if get_parent().is_in_group("wires"):
			texture = $"../../..".wire_texture
		else:
			texture = $"../../..".slot_texture
	else:
		visible = false
	position = -texture.get_size() / 2
	
