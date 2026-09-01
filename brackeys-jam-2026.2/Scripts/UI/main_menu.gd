extends Control

@export var new_game_scene: String = "res://Levels/submarine.tscn"
@export var options_scene: String = "res://Levels/options_menu.tscn"
@export var credits_scene: String = "res://Levels/credits_menu.tscn"
var loading_scene: String = "res://Levels/loading.tscn"

func _on_options_pressed() -> void:
	var options = load(options_scene)
	if options:
		var options_instance = options.instantiate()
		get_tree().current_scene.add_child(options_instance)

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_credits_pressed() -> void:
	var credits = load(credits_scene)
	if credits:
		var credits_instance = credits.instantiate()
		get_tree().current_scene.add_child(credits_instance)


func _on_new_game_pressed() -> void:
	GameState.scene_to_load = new_game_scene
	get_tree().change_scene_to_file(loading_scene)
