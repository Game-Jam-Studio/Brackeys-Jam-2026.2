extends Node

var test_narrative_text := {}
@export var shipHealthControl: Control

var storyTrackerDictionary: Dictionary = {}

var nextTextKey: String = ""


func load_csv_to_dictionary(file_path: String, key_column: String = "Line ID", delimiter: String = ",") -> Dictionary:
	var file := FileAccess.open(file_path, FileAccess.READ)
	if not file:
		push_error("Failed to open CSV file: " + file_path)
		return test_narrative_text
	
	var headers := file.get_csv_line(delimiter)
	if headers.is_empty() or headers[0] == "":
		return test_narrative_text
		
	var key_index := headers.find(key_column)
	if key_index == -1:
		push_error("Key column '" + key_column + "' not found in CSV headers.")
		return test_narrative_text
		
	while !file.eof_reached():
		var row := file.get_csv_line(delimiter)
		
		# Skip empty or malformed trailing rows
		if row.is_empty() or row.size() < headers.size():
			continue
			
		var row_data := {}
		for i in range(headers.size()):
			row_data[headers[i]] = row[i]
			
		# Store row data under its unique key identifier
		var primary_key_value = row[key_index]
		test_narrative_text[primary_key_value] = row_data

	file.close()
	
	return test_narrative_text


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	test_narrative_text = load_csv_to_dictionary("res://Narrative/Dialogue.csv")
	for row in test_narrative_text:
		#print(test_narrative_text[row]["Line ID"] + " " + test_narrative_text[row]["Next ID"])
		pass
	#show_next_text("Intro-001")
	
	# Explicitly hide the UI on launch to override the editor visibility state
	$CanvasLayer.visible = false


# CurrKeys SubmarineLevel, RhythmLevel, PressureLevel, SteamLevel
func show_next_text(LineID: String) -> void:
	nextTextKey = ""
	if test_narrative_text.has(LineID):
		nextTextKey = test_narrative_text[LineID]["Next ID"]
		launch_terminal(test_narrative_text[LineID]["Line"])
	else:
		push_error("ERROR - tried to launch narrative text that has no key in the narrative dictionary")
		launch_terminal("This subsystem doesn't exist.")


# Example usage of launchTerminal - TerminalUI.launch_terminal("show some text\nsomemoretext")
# BBCode example: log_label.text = "You take [color=crimson][font_size=24]50[/font_size] damage[/color]!"
func launch_terminal(text: String) -> void:
	# only send pause signal if opening for the first time
	if $CanvasLayer.visible == false:
		get_tree().current_scene.get_node_or_null("%PauseMenu").pause()
	$CanvasLayer/TerminalText.text = "[color=green][font_size=30]"+text+"[/font_size][/color]"
	$CanvasLayer.visible = true


func close_terminal() -> void:
	shipHealthControl.visible = false
	get_tree().current_scene.get_node_or_null("%PauseMenu").try_resume()
	$CanvasLayer.visible = false


# Resume button
func _on_button_pressed() -> void:
	if nextTextKey != "":
		show_next_text(nextTextKey)
	else:
		close_terminal()
