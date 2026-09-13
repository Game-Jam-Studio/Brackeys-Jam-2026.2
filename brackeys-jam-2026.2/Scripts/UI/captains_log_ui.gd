extends CanvasLayer

@onready var log_text: RichTextLabel = $TextureRect/LogText
@onready var close_button: Button = $CloseButton

var next_text_key: String = ""

func _ready() -> void:
	visible = false
	close_button.pressed.connect(_on_close_pressed)


func show_log(line_id: String) -> void:
	next_text_key = ""
	if PopupUI.test_narrative_text.has(line_id):
		var entry = PopupUI.test_narrative_text[line_id]
		next_text_key = entry["Next ID"]
		log_text.text = entry["Line"]
		close_button.text = "Next" if next_text_key != "" else "Close"
		if not visible:
			visible = true
			get_tree().current_scene.get_node_or_null("%PauseMenu").pause()
	else:
		push_error("Captains log line_id not found: " + line_id)


func _on_close_pressed() -> void:
	if next_text_key != "":
		show_log(next_text_key)
	else:
		visible = false
		get_tree().current_scene.get_node_or_null("%PauseMenu").try_resume()
