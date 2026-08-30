@tool
extends Node3D

@export var screen_textures: Array[Texture2D] = []

@onready var screen_sprite: Sprite3D = $ScreenDecal

func _ready() -> void:
	update_screen()

func update_screen() -> void:
	if screen_textures.is_empty() or not screen_sprite:
		return
	if Engine.is_editor_hint():
		screen_sprite.texture = screen_textures[0]
	else:
		screen_sprite.texture = screen_textures.pick_random()
