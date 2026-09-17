extends Node3D
var scene_3d: String = "res://Van/Levels/MainMenuScenes/main_menu_3d.tscn"
var scene: Node

func _ready() -> void:
	await get_tree().create_timer(.5).timeout
	scene = load(scene_3d).instantiate()
	for object in scene.get_children():
		scene.call_deferred("remove_child", object)
		call_deferred("add_child", object)
		print(object)
		await get_tree().process_frame
