extends Control
@onready var color_rect: ColorRect = $ColorRect
@onready var accept_button: Button = $VBoxContainer/Accept
@onready var good_job: Label = $"Good Job"

var deltaTime : float = 0.0

@export var tolerance: float = 0.15


func _process(delta: float) -> void:
	color_rect.rotation = deg_to_rad(180) + sin(deltaTime * 4)
	deltaTime += delta
	if is_equal_custom(abs(color_rect.rotation), deg_to_rad(180), tolerance):
		color_rect.color = Color.GREEN
	else:
		color_rect.color = Color.RED


func _on_button_button_down() -> void:
	if is_equal_custom(abs(color_rect.rotation), deg_to_rad(180), tolerance):
		good_job.visible = true
		accept_button.visible = false
		color_rect.visible = false
	else:
		print("FAILER!")

func is_equal_custom(a, b, tolerance):
	return abs(a - b) <= tolerance


func _on_close_button_down() -> void:
	get_tree().quit()
