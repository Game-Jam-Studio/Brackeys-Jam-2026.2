extends CanvasLayer

@onready var log_text: RichTextLabel = $TextureRect/LogText
@onready var close_button: Button = $CloseButton
@onready var tally_overlay: Control = $TextureRect/TallyOverlay
@onready var tally2: TextureRect = $TextureRect/TallyOverlay/Tally2
@onready var tally3: TextureRect = $TextureRect/TallyOverlay/Tally3

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
		
		tally_overlay.visible = line_id in ["A2L3-004", "A2L3-005"]
		tally2.visible = line_id == "A2L3-004"
		tally3.visible = line_id == "A2L3-005"
		
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
