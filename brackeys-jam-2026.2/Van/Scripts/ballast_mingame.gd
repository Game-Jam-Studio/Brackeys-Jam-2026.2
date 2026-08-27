extends Control
@onready var color_rect: ColorRect = $ColorRect
@onready var accept_button: Button = %Accept
const UI_ACCEPT = preload("uid://ci0u00xywksjx")
const UI_ERROR = preload("uid://44cjuy6hy1ge")

# Emitted on outcome so the caller can return the camera and call end_repair() on the trigger.
signal minigame_completed(success: bool)

var deltaTime : float = 0.0
var submitted: bool

@export var tolerance: float = 10
@export var speed: float = 10

func _ready() -> void:
	$TextureProgressBar.value = tolerance


func _process(delta: float) -> void:
	if !submitted:
		color_rect.rotation = sin(deltaTime * speed)
		deltaTime += delta


func _unhandled_input(event: InputEvent) -> void:
	# Press [ - ] (Minus) to deal 10 damage to the ship
	if event.is_action_pressed("ui_text_backspace") or (event is InputEventKey and event.pressed and event.keycode == KEY_MINUS):
		GameState.ship_health -= 10.0
	
	# Press [ = ] (Equal / Plus) to heal 10 damage
	elif event is InputEventKey and event.pressed and event.keycode == KEY_EQUAL:
		GameState.ship_health += 10.0


func _on_button_button_down() -> void:
	submitted = true
	if is_equal_custom(abs(color_rect.rotation), deg_to_rad(0), deg_to_rad(tolerance / 1.5)):
		accept_button.visible = false
		$AudioStreamPlayer.play()
		await get_tree().create_timer(.5).timeout
		minigame_completed.emit(true)
		queue_free()
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
