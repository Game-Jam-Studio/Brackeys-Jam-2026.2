extends Control

@onready var liquid_fill: ColorRect = $LiquidMask/LiquidFill
@onready var health_frame: TextureRect = $FrameBase
@onready var frame_overlay: TextureRect = $FrameOverlay

@export var frame_base: Texture2D
@export var frame_mid: Texture2D
@export var frame_corrupted: Texture2D

var fill_material: ShaderMaterial
var fill_tween: Tween
var frame_tween: Tween

var highest_unlocked_tier: int = 1

# Color definitions for Green, Yellow, & Red states
var color_palette: Dictionary = {
	"green": {
		"crest": Color(0.92, 0.98, 0.65, 1.0),
		"body": Color(0.655, 0.812, 0.165, 1.0),
		"deep": Color(0.32, 0.45, 0.08, 1.0),
		"back": Color(0.48, 0.65, 0.15, 0.75)
	},
	"yellow": {
		"crest": Color(0.98, 0.95, 0.65, 1.0),
		"body": Color(0.941, 0.867, 0.290, 1.0),
		"deep": Color(0.580, 0.40, 0.016, 1.0),
		"back": Color(0.702, 0.565, 0.012, 0.75)
	},
	"red": {
		"crest": Color(0.773, 0.208, 0.275, 1.0),
		"body": Color(0.820, 0.220, 0.220, 1.0),
		"deep": Color(0.290, 0.035, 0.035, 1.0),
		"back": Color(0.369, 0.067, 0.067, .75)
	}
}


func _ready() -> void:
	# Cast and store the shader material
	fill_material = liquid_fill.material as ShaderMaterial
	
	GameState.ship_health_changed.connect(_on_ship_health_changed)
	GameState.area_unlocked.connect(_on_area_unlocked)
	
	# Apply the current health on load to prevent desync
	_update_display(GameState.ship_health)


func _unhandled_input(event: InputEvent) -> void:
	# Press [ - ] (Minus) to deal 10 damage to the ship
	if event.is_action_pressed("ui_text_backspace") or (event is InputEventKey and event.pressed and event.keycode == KEY_MINUS):
		GameState.ship_health -= 10
		
	# Press [ = ] (Equal / Plus) to heal 10 damage
	elif event is InputEventKey and event.pressed and event.keycode == KEY_EQUAL:
		GameState.ship_health += 10


func _on_ship_health_changed(new_health: float) -> void:
	_update_display(new_health)


func _on_area_unlocked(_new_level: int) -> void:
	_update_display(GameState.ship_health)


func _update_display(health: float) -> void:	
	if not fill_material:
		return

	var normalized: float = clampf(health / GameState.MAX_SHIP_HEALTH, 0.0, 1.0)
	
	if health <= 25.0 or GameState.current_area_level >= 3:
		highest_unlocked_tier = maxi(highest_unlocked_tier, 3)
	elif health <= 50.0 or GameState.current_area_level >= 2:
		highest_unlocked_tier = maxi(highest_unlocked_tier, 2)
		
	var target_texture: Texture2D = frame_base
	if highest_unlocked_tier == 3 and frame_corrupted:
		target_texture = frame_corrupted
	elif highest_unlocked_tier == 2 and frame_mid:
		target_texture = frame_mid
	
	if health_frame.texture != target_texture:
		if frame_overlay:
			if frame_tween and frame_tween.is_valid():
				frame_tween.kill()
			
			# Put the current (old) texture on the overlay and make it fully visible on top
			frame_overlay.texture = health_frame.texture
			frame_overlay.modulate.a = 1.0
			
			# Instantly update the base frame underneath to the new target texture
			health_frame.texture = target_texture
			
			# Smoothly fade out the overlay to reveal the new base texture beneath it
			frame_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			frame_tween.tween_property(frame_overlay, "modulate:a", 0.0, 0.5)
	
	var current_fill: float = fill_material.get_shader_parameter("fill_amount")
	
	if fill_tween and fill_tween.is_valid():
		fill_tween.kill()
	
	fill_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	fill_tween.tween_method(_apply_liquid_color, current_fill, normalized, 0.4)


func _apply_liquid_color(normalized: float) -> void:
	# Update vertical fill
	fill_material.set_shader_parameter("fill_amount", normalized)
	# Calculate blended colors across 3 health tiers
	var current_crest: Color
	var current_body: Color
	var current_deep: Color
	var current_back: Color
	
	var yellow_threshold: float = 0.60 # Hits pure yellow at 60% health
	var red_threshold: float = 0.25    # Reaches pure red at 25% health
	
	if normalized >= yellow_threshold:
		var weight: float = (normalized - yellow_threshold) / (1.0 - yellow_threshold)
		current_crest = color_palette["yellow"]["crest"].lerp(color_palette["green"]["crest"], weight)
		current_body = color_palette["yellow"]["body"].lerp(color_palette["green"]["body"], weight)
		current_deep = color_palette["yellow"]["deep"].lerp(color_palette["green"]["deep"], weight)
		current_back = color_palette["yellow"]["back"].lerp(color_palette["green"]["back"], weight)
	elif normalized >= red_threshold:
		var weight: float = (normalized - red_threshold) / (yellow_threshold - red_threshold)
		current_crest = color_palette["red"]["crest"].lerp(color_palette["yellow"]["crest"], weight)
		current_body = color_palette["red"]["body"].lerp(color_palette["yellow"]["body"], weight)
		current_deep = color_palette["red"]["deep"].lerp(color_palette["yellow"]["deep"], weight)
		current_back = color_palette["red"]["back"].lerp(color_palette["yellow"]["back"], weight)
	else:
		current_crest = color_palette["red"]["crest"]
		current_body = color_palette["red"]["body"]
		current_deep = color_palette["red"]["deep"]
		current_back = color_palette["red"]["back"]
	
	# Push the calculated colors to the liquid shader
	fill_material.set_shader_parameter("crest_glow_color", current_crest)
	fill_material.set_shader_parameter("body_color", current_body)
	fill_material.set_shader_parameter("deep_color", current_deep)
	fill_material.set_shader_parameter("back_wave_color", current_back)
