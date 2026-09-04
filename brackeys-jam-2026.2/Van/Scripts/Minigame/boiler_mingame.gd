extends Control
@onready var color_rect: TextureRect = $Needle
@onready var accept_button: TextureButton = %Accept
@onready var progress_bar: TextureProgressBar = $ValidArea
@onready var audio: AudioStreamPlayer = %AudioStreamPlayer
const UI_ACCEPT = preload("res://Audio/SFX/UI_accept.wav")
const UI_ACCEPT_CORRUPTED = preload("res://Audio/SFX/UI_accept_corrupted.wav")
const UI_ERROR = preload("res://Audio/SFX/UI_error.wav")
const UI_ERROR_CORRUPTED = preload("res://Audio/SFX/UI_error_corrupted.wav")

# Emitted on outcome so the caller can return the camera and call end_repair() on the trigger.
signal minigame_completed(success: bool)

var submitted: bool
var completed_rounds: float
var error_sound: AudioStreamWAV
var accept_sound: AudioStreamWAV


@export var tolerance: float = 15
@export var number_of_rounds: int = 3
@export var speed: float = 1.5
@export var speed_multiplier_per_round: float = 1.25
##Minimum value for the random degree rotation of the goal (zero is the bottom middle of the screen)
@export var goal_min_range: float = 30
##Maximum value for the random degree rotation of the goal (zero is the bottom middle of the screen)
@export var goal_max_range: float = 90

func _ready() -> void:
	if ProgressionManager.get_minigame_tier(GameState.ship_health, GameState.MAX_SHIP_HEALTH) == 3:
		accept_sound = UI_ACCEPT_CORRUPTED
		error_sound = UI_ERROR_CORRUPTED
	else:
		accept_sound = UI_ACCEPT
		error_sound = UI_ERROR
	var needle_texture = ProgressionManager.get_asset_texture("boiler", "needle")
	var meter_texture = ProgressionManager.get_asset_texture("boiler", "meter")
	var button_texture = ProgressionManager.get_asset_texture("boiler", "button")
	$Needle.texture = needle_texture
	$Meter.texture = meter_texture
	%Accept.texture_normal = button_texture
	progress_bar.value = tolerance
	progress_bar.rotation_degrees = randf_range(-goal_min_range, -goal_max_range) + 180
	color_rect.rotation = PI / 2

func _process(delta: float) -> void:
	if !submitted:
		# Rotate Needle
		color_rect.rotation += -delta * speed
		# Player doesn't press the button in time
		if  color_rect.rotation < progress_bar.rotation - PI - deg_to_rad(tolerance) and !submitted:
			accept_button.visible = false
			submitted = true
			$AudioStreamPlayer.stream = error_sound
			$AudioStreamPlayer.play()
			await get_tree().create_timer(.5).timeout
			minigame_completed.emit(false)
			queue_free()


func _unhandled_input(event: InputEvent) -> void:
	# Press [ - ] (Minus) to deal 10 damage to the ship
	if event.is_action_pressed("ui_text_backspace") or (event is InputEventKey and event.pressed and event.keycode == KEY_MINUS):
		GameState.ship_health -= 10.0
	
	# Press [ = ] (Equal / Plus) to heal 10 damage
	elif event is InputEventKey and event.pressed and event.keycode == KEY_EQUAL:
		GameState.ship_health += 10.0


func _on_button_button_down() -> void:
	if is_equal_custom(color_rect.rotation, progress_bar.rotation - PI, deg_to_rad(tolerance / 1.5)):
		completed_rounds += 1
		if completed_rounds >= number_of_rounds:
			submitted = true
			audio.stream = accept_sound
			audio.play()
			await get_tree().create_timer(.5).timeout
			minigame_completed.emit(true)
			queue_free()
			return
		progress_bar.rotation_degrees = randf_range(-goal_min_range, -goal_max_range) + 180
		color_rect.rotation = PI / 2
		speed = speed * speed_multiplier_per_round
		audio.stream = accept_sound
		audio.play()
	else:
		accept_button.visible = false
		submitted = true
		$AudioStreamPlayer.stream = error_sound
		$AudioStreamPlayer.play()
		await get_tree().create_timer(.5).timeout
		minigame_completed.emit(false)
		queue_free()

func is_equal_custom(a, b, adjustedTolerance):
	return abs(a - b) <= adjustedTolerance
