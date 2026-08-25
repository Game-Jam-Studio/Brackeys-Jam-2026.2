extends Node

# Framework that pauses player movement/input, mounts an overlay 
# (Minigame/Log/Terminal), and restores control on close.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
# Example usage of launchTerminal - TerminalUI.launch_terminal("show some text\nsomemoretext")
# BBCode example: log_label.text = "You take [color=crimson][font_size=24]50[/font_size] damage[/color]!"
func launch_terminal(text: String) -> void:
	get_tree().paused = true
	$CanvasLayer/TerminalText.text = "[color=green][font_size=30]"+text+"[/font_size][/color]"
	$CanvasLayer.visible = true
	
func close_terminal() -> void:
	get_tree().paused = false
	$CanvasLayer.visible = false

# Resume button
func _on_button_pressed() -> void:
	close_terminal()
