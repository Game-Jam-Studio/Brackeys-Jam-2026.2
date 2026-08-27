extends Control

@onready var resume_button: Button = $CanvasLayer/BlurBackground/CenterContainer/MenuBackground/ButtonContainer/ResumeButton
@onready var main_menu_button: Button = $CanvasLayer/BlurBackground/CenterContainer/MenuBackground/ButtonContainer/MainMenuButton
@onready var quit_button: Button = $CanvasLayer/BlurBackground/CenterContainer/MenuBackground/ButtonContainer/QuitButton

var pause_counter: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Hide the pause menu by default on startup.
	$CanvasLayer.visible = false
	pass


func _unhandled_input(event: InputEvent) -> void:
	# Listens for the "ui_cancel" action (Escape / UI Back).
	if event.is_action_pressed("ui_cancel"):
		# whether we should have escape be a pause or resume to the player
		# is just based on whether they currently see the pause menu or not
		if $CanvasLayer.visible:
			try_resume()
		else:
			pause()
		_toggle_menu_visibility()
		#get_viewport().set_input_as_handled()
	
func pause() -> void:
	pause_counter += 1
	get_tree().paused = true
	
func try_resume() -> void:
	pause_counter -= 1
	if pause_counter <= 0:
		pause_counter = 0
		get_tree().paused = false

func _on_resume_button_pressed() -> void:
	try_resume()
	$CanvasLayer.visible = false

func _toggle_menu_visibility() -> void:
	$CanvasLayer.visible = !$CanvasLayer.visible

func _on_main_menu_button_pressed() -> void:
	# Must unpause the tree before loading scenes, or the new scene starts paused
	# 
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Levels/main_menu.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
