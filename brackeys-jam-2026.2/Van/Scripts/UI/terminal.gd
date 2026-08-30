extends Control

signal terminal_closed

func _on_texture_button_pressed() -> void:
	terminal_closed.emit()
