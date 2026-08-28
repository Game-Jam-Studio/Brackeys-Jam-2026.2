extends Node

# AI Font Progression
const AI_THEME_BASE = preload("res://Resources/Themes/AI_base_theme.tres")
const AI_THEME_MID = preload("res://Resources/Themes/AI_mid_theme.tres")
const AI_THEME_CORRUPTED = preload("res://Resources/Themes/AI_corrupted_theme.tres")

# Ship Health Frames
const FRAME_BASE = preload("res://Art/2D/ShipHealth/health_frame_base.png") 
const FRAME_MID = preload("res://Art/2D/ShipHealth/health_frame_mid.png")
const FRAME_CORRUPTED = preload("res://Art/2D/ShipHealth/health_frame_corrupted.png")

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
		"gauge": {"base": "res://Art/2D/Ballast/gauge_base.png", "corrupted": "res://Art/2D/Ballast/gauge_base.png"}, # TODO: replace corrupted value
		"needle": {"base": "res://Art/2D/Ballast/needle_base.png", "corrupted": "res://Art/2D/Ballast/needle_base.png"}, # TODO: replace corrupted value
		"valid_area": {"base": "res://Art/2D/Ballast/valid_area_base.png", "corrupted": "res://Art/2D/Ballast/valid_area_base.png"}, # TODO: replace corrupted value
		"dial": {"base": "res://Art/2D/Ballast/dial_base.png", "corrupted": "res://Art/2D/Ballast/dial_base.png"} # TODO: replace corrupted value
	},
	#"boiler": {
	#	"needle": {"base": , "corrupted": },
	#	"valid_area": {"base": , "corrupted": }
	#},
	#"circuit": {
	#	"slot": {"base": "res://assets/circuit/slot_base.png", "corrupted": "res://assets/circuit/slot_corrupted.png"},
	#	"wire": {"base": "res://assets/circuit/wire_base.png", "corrupted": "res://assets/circuit/wire_corrupted.png"}
	#}
}


func get_current_tier(health: float, max_health: float) -> int:
	var normalized: float = clampf(health / max_health, 0.0, 1.0)
	if normalized <= 0.30 or GameState.current_area_level >= 3:
		return 3
	elif normalized <= 0.66 or GameState.current_area_level >= 2:
		return 2
	return 1

func get_ai_theme(tier: int) -> Theme:
	match tier:
		3: return AI_THEME_CORRUPTED
		2: return AI_THEME_MID
		_: return AI_THEME_BASE

func get_asset_texture(minigame: String, asset_name: String, tier: int) -> Texture2D:
	if ASSET_PATHS.has(minigame) and ASSET_PATHS[minigame].has(asset_name):
		var key = "corrupted" if tier == 3 else "base"
		var path = ASSET_PATHS[minigame][asset_name][key]
		if ResourceLoader.exists(path):
			return load(path)
	return null

func get_destination_transform(tier: int) -> Dictionary:
	if tier == 3:
		return TRANSFORM_CORRUPTED
	return TRANSFORM_BASE
