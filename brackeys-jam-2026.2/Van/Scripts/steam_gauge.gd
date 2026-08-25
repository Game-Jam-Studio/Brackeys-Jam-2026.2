extends Control
var valid_rotation: float
@onready var steam_hacking_game: Control = $".."
@onready var valid_area: TextureRect = $Housing/ValidArea
@onready var needle: TextureRect = $Housing/Needle
@onready var dial_1: TextureRect = $"../Controls/Dial1"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await steam_hacking_game.ready
	valid_area.rotation = remap(steam_hacking_game.gauge_1, 0, 1, -deg_to_rad(dial_1.max_rotation), deg_to_rad(dial_1.max_rotation))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_dial_1_value_changed(value: Variant) -> void:
	needle.rotation = remap(value, 0, 1, -deg_to_rad(dial_1.max_rotation), deg_to_rad(dial_1.max_rotation))
