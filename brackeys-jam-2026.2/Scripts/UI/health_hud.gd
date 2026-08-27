extends Control

@onready var liquid_fill: ColorRect = $LiquidMask/LiquidFill

var fill_material: ShaderMaterial
var fill_tween: Tween


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
	
	# Apply the current health on load to prevent desync
	_update_liquid_display(GameState.ship_health)


func _on_ship_health_changed(new_health: float) -> void:
	_update_liquid_display(new_health)


# Updates shader fill height smoothly and blends colors based on current ship health
func _update_liquid_display(health: float) -> void:	
	if not fill_material:
		return
	
	# Normalize health to a 0.0 - 1.0 range
	var normalized: float = clampf(health / GameState.MAX_SHIP_HEALTH, 0.0, 1.0)
	var current_fill: float = fill_material.get_shader_parameter("fill_amount")
	
	# Kill existing tween if taking continuous damage
	if fill_tween and fill_tween.is_valid():
		fill_tween.kill()
	
	# Create a smooth transition tween
	fill_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# Animate a custom step method over 0.4 seconds
	fill_tween.tween_method(_apply_liquid_frame, current_fill, normalized, 0.4)


func _apply_liquid_frame(normalized: float) -> void:
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
