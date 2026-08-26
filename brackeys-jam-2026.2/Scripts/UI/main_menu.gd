extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/submarine_dev_version.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/options_menu.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/credits_menu.tscn")
