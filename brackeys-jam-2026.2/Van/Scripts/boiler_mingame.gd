extends Control
@onready var color_rect: ColorRect = $Needle
@onready var accept_button: Button = %Accept
@onready var progress_bar: TextureProgressBar = $ValidArea
@onready var audio: AudioStreamPlayer = %AudioStreamPlayer
const UI_ACCEPT = preload("uid://ci0u00xywksjx")
const UI_ERROR = preload("uid://44cjuy6hy1ge")



# Emitted on outcome so the caller can return the camera and call end_repair() on the trigger.
signal minigame_completed(success: bool)

var submitted: bool
var completed_rounds: float

@export var tolerance: float = 15
@export var number_of_rounds: int = 5
@export var speed: float = 1.5
@export var speed_multiplier_per_round: float = 1.25
##Minimum value for the random degree rotation of the goal (zero is the bottom middle of the screen)
@export var goal_min_range: float = 30
##Maximum value for the random degree rotation of the goal (zero is the bottom middle of the screen)
@export var goal_max_range: float = 90

func _ready() -> void:
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
			$AudioStreamPlayer.stream = UI_ERROR
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
			audio.stream = UI_ACCEPT
			audio.play()
			await get_tree().create_timer(.5).timeout
			minigame_completed.emit(false)
			queue_free()
			return
		progress_bar.rotation_degrees = randi_range(-goal_min_range, -goal_max_range) + 180
		color_rect.rotation = PI / 2
		speed = speed * speed_multiplier_per_round
		audio.stream = UI_ACCEPT
		audio.play()
	else:
		accept_button.visible = false
		submitted = true
		$AudioStreamPlayer.stream = UI_ERROR
		$AudioStreamPlayer.play()
		await get_tree().create_timer(.5).timeout
		minigame_completed.emit(false)
		queue_free()

func is_equal_custom(a, b, adjustedTolerance):
	return abs(a - b) <= adjustedTolerance
