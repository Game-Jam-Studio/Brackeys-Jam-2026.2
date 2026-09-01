extends Control
@export var new_game_scene: String = "res://Levels/submarine.tscn"
@export var options_scene: String = "res://Levels/options_menu.tscn"
@export var credits_scene: String = "res://Levels/credits_menu.tscn"
var loading_scene: String = "res://Levels/loading.tscn"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file(options_scene)


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file(credits_scene)


func _on_new_game_pressed() -> void:
	GameState.scene_to_load = new_game_scene
	get_tree().change_scene_to_file(loading_scene)
