extends Button

@export var popup_ui: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _on_pressed() -> void:
	popup_ui.show_next_text("SubmarineLevel")
