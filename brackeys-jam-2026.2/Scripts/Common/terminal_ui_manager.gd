extends Node

# Framework that pauses player movement/input, mounts an overlay 
# (Minigame/Log/Terminal), and restores control on close.

@export var narrativeText: Dictionary = {}

var storyTrackerDictionary: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# CurrKeys SubmarineLevel, RhythmLevel, PressureLevel, SteamLevel
func show_next_text(levelKey: String) -> void:
	if not storyTrackerDictionary.has(levelKey):
		storyTrackerDictionary[levelKey] = 0
	else:
		storyTrackerDictionary[levelKey] += 1
	if narrativeText.has(levelKey):
		if len(narrativeText[levelKey]) > storyTrackerDictionary[levelKey]:
			launch_terminal(narrativeText[levelKey][storyTrackerDictionary[levelKey]])
		else:
			push_warning("WARNING - Player has reached the end of our narrative text for " + levelKey)
			launch_terminal("erro...dkj clic - ugh - groan*")
	else:
		push_error("ERROR - tried to launch narrative text that has no key in the narrative dictionary")
		launch_terminal("This subsystem doesn't exist.")
	
	
# Example usage of launchTerminal - TerminalUI.launch_terminal("show some text\nsomemoretext")
# BBCode example: log_label.text = "You take [color=crimson][font_size=24]50[/font_size] damage[/color]!"
func launch_terminal(text: String) -> void:
	get_tree().current_scene.get_node_or_null("%PauseMenu").pause()
	$CanvasLayer/TerminalText.text = "[color=green][font_size=30]"+text+"[/font_size][/color]"
	$CanvasLayer.visible = true
	
func close_terminal() -> void:
	get_tree().current_scene.get_node_or_null("%PauseMenu").try_resume()
	$CanvasLayer.visible = false

# Resume button
func _on_button_pressed() -> void:
	
	close_terminal()
