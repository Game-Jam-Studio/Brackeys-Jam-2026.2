extends Control
@onready var color_rect: ColorRect = $ColorRect
@onready var accept_button: Button = $VBoxContainer/Accept

var deltaTime : float = 0.0

@export var tolerance: float = 10


func _process(delta: float) -> void:
	color_rect.rotation = deg_to_rad(0) + sin(deltaTime * 4)
	deltaTime += delta
	if is_equal_custom(abs(color_rect.rotation), deg_to_rad(0), deg_to_rad(tolerance)):
		color_rect.color = Color.GREEN
	else:
		color_rect.color = Color.RED


func _on_button_button_down() -> void:
	if is_equal_custom(abs(color_rect.rotation), deg_to_rad(0), deg_to_rad(tolerance)):
		$Conditions/Success.visible = true
		$VBoxContainer/Accept.visible = false
		accept_button.visible = false
		color_rect.visible = false
	#Win signal goes here
		print("YOU WIN!")
		await get_tree().create_timer(2).timeout
		queue_free()
	else:
		$Conditions/Failure.visible = true
		$VBoxContainer/Accept.visible = false
		accept_button.visible = false
		color_rect.visible = false
	#Win signal goes here
		print("YOU LOSE!")
		await get_tree().create_timer(2).timeout
		queue_free()

func is_equal_custom(a, b, tolerance):
	return abs(a - b) <= tolerance
