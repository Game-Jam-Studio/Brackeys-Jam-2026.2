extends Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _on_pressed() -> void:
	PopupUI.show_next_text("Intro-001")
	#PopupUI.show_ship_status()
