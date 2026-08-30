extends Node

signal area_unlocked(new_level: int)

var current_area_level: int = 1

# AI Font Progression
const AI_THEME_BASE = preload("res://Resources/Themes/AI_base_theme.tres")
const AI_THEME_MID = preload("res://Resources/Themes/AI_mid_theme.tres")
const AI_THEME_CORRUPTED = preload("res://Resources/Themes/AI_corrupted_theme.tres")

# Ship Health Frames
const FRAME_BASE = preload("res://Art/2D/ShipHealth/health_frame_base.png") 
const FRAME_MID = preload("res://Art/2D/ShipHealth/health_frame_mid.png")
const FRAME_CORRUPTED = preload("res://Art/2D/ShipHealth/health_frame_corrupted.png")

# Sound Effects
const UI_DIAL_SHORT = preload("uid://f5we04nn8mkj")
const UI_DIAL_CORRUPTED = preload("uid://j0q4lsv21hnn")
const UI_ACCEPT = preload("uid://ci0u00xywksjx")
const UI_ACCEPT_CORRUPTED = preload("uid://ddqgwbhtje3a2")

func get_frame_texture(tier: int) -> Texture2D:
	match tier:
		3: return FRAME_CORRUPTED
		2: return FRAME_MID
		_: return FRAME_BASE

# [Sonar Minigame] Destination Transforms
const TRANSFORM_BASE = {
	"position": Vector2(0.0, 40.685),
	"scale": Vector2(0.25, 0.523)
}
const TRANSFORM_CORRUPTED = {
	"position": Vector2(-1.11, 63.465),
	"scale": Vector2(0.272, 0.407)
}

# Asset mappings per minigame
const ASSET_PATHS = {
	"sonar": {
		"destination": {"base": "res://Art/2D/Sonar/destination_base.png", "corrupted": "res://Art/2D/Sonar/destination_corrupted.png"},
		"note": {"base": "res://Art/2D/Sonar/note_base.png", "corrupted": "res://Art/2D/Sonar/note_corrupted.png"},
		"circle": {"base": "res://Art/2D/Sonar/circle_base.png", "corrupted": "res://Art/2D/Sonar/circle_corrupted.png"},
		"cone": {"base": "res://Art/2D/Sonar/cone_base.png", "corrupted": "res://Art/2D/Sonar/cone_corrupted.png"}
	},
	"ballast": {
		"gauge": {"base": "res://Art/2D/Ballast/gauge_base.png", "corrupted": "res://Art/2D/Ballast/gauge_corrupted.png"},
		"needle": {"base": "res://Art/2D/Ballast/needle_base.png", "corrupted": "res://Art/2D/Ballast/needle_corrupted.png"},
		"valid_area": {"base": "res://Art/2D/Ballast/valid_area_base.png", "corrupted": "res://Art/2D/Ballast/valid_area_corrupted.png"},
		"dial": {"base": "res://Art/2D/Ballast/dial_base.png", "corrupted":"res://Art/2D/Ballast/dial_corrupted.png" }
	},
	"boiler": {
		"needle": {"base": "res://Art/2D/Boiler/pointer_base.png", "corrupted": "res://Art/2D/Boiler/pointer_corrupted.png"},
		"meter": {"base": "res://Art/2D/Boiler/meter_base.png", "corrupted": "res://Art/2D/Boiler/meter_corrupted.png"},
		"button": {"base": "res://Art/2D/Boiler/button_base.png", "corrupted": "res://Art/2D/Boiler/button_corrupted.png"}
	},
	"circuit": {
		"wire_middle": {"base": "res://Art/2D/Circuit/Wires/wire_middle_base.png", "corrupted": "res://Art/2D/Circuit/Wires/wire_middle_corrupted.png"},
		"wire_end": {"base": "res://Art/2D/Circuit/Wires/wire_end_base.png", "corrupted": "res://Art/2D/Circuit/Wires/wire_end_corrupted.png"}
	}
	
}

# Paths for Circuit minigame
const CIRCUIT_SLOTS = {
	"base": [
		"res://Art/2D/Circuit/Slots/slot_base_blue.png",
		"res://Art/2D/Circuit/Slots/slot_base_gray.png",
		"res://Art/2D/Circuit/Slots/slot_base_green.png",
		"res://Art/2D/Circuit/Slots/slot_base_orange.png",
		"res://Art/2D/Circuit/Slots/slot_base_red.png",
		"res://Art/2D/Circuit/Slots/slot_base_yellow.png"
			],
	"corrupted": [
		"res://Art/2D/Circuit/Slots/slot_corrupted_blue.png",
		"res://Art/2D/Circuit/Slots/slot_corrupted_green.png",
		"res://Art/2D/Circuit/Slots/slot_corrupted_olive.png",
		"res://Art/2D/Circuit/Slots/slot_corrupted_orange.png",
		"res://Art/2D/Circuit/Slots/slot_corrupted_pink.png",
		"res://Art/2D/Circuit/Slots/slot_corrupted_purple.png"
		]
	}


func get_circuit_slots() -> Array[Texture2D]:
	var tier = get_minigame_tier(GameState.ship_health, GameState.MAX_SHIP_HEALTH)
	var key = "corrupted" if tier == 3 else "base"
	var textures: Array[Texture2D] = []
	
	for path in CIRCUIT_SLOTS[key]:
		if ResourceLoader.exists(path):
			var tex = load(path)
			if tex:
				textures.append(tex)
	return textures


func get_ship_tier(health: float, max_health: float) -> int:
	var normalized: float = clampf(health / max_health, 0.0, 1.0)
	if normalized <= 0.30 or GameState.current_area_level >= 3:
		return 3
	elif normalized <= 0.66 or GameState.current_area_level >= 2:
		return 2
	return 1


func get_minigame_tier(health: float, max_health: float) -> int:
	# TEMPORARY OVERRIDE FOR TESTING CORRUPTED ART
	#return 3
	
	var normalized: float = clampf(health / max_health, 0.0, 1.0)
	if normalized <= 0.50 or GameState.current_area_level >= 3:
		return 3
	return 1


func get_asset_texture(minigame: String, asset_name: String) -> Texture2D:
	var tier = get_minigame_tier(GameState.ship_health, GameState.MAX_SHIP_HEALTH)
	if ASSET_PATHS.has(minigame) and ASSET_PATHS[minigame].has(asset_name):
		var key = "corrupted" if tier == 3 else "base"
		var path = ASSET_PATHS[minigame][asset_name][key]
		
		if not ResourceLoader.exists(path):
			return null
		
		var texture = load(path)
		if not texture:
			return null
		
		return texture
	return null


func get_ai_theme(tier: int) -> Theme:
	# Return your appropriate Theme resource based on the tier
	match tier:
		1:
			return preload("res://Resources/Themes/AI_base_theme.tres")
		2:
			return preload("res://Resources/Themes/AI_mid_theme.tres")
		_:
			return preload("res://Resources/Themes/AI_corrupted_theme.tres")


# where did this come from?
func get_destination_transform(tier: int) -> Dictionary:
	if tier == 3:
		return TRANSFORM_CORRUPTED
	return TRANSFORM_BASE


func unlock_next_area(level: int) -> void:
	current_area_level = level
	area_unlocked.emit(current_area_level)
	
