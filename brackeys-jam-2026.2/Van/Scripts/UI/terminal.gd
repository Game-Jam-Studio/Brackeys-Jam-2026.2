extends Control

signal terminal_closed

@onready var ballast_health: ProgressBar = %BallastHealth
@onready var boiler_health: ProgressBar = %BoilerHealth
@onready var circuit_health: ProgressBar = %CircuitHealth
@onready var sonar_health: ProgressBar = %"Sonar Health"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.ballast_health_changed.connect(_ballast_health_changed)
	GameState.boiler_health_changed.connect(_boiler_health_changed)
	GameState.circuit_health_changed.connect(_circuit_health_changed)
	GameState.sonar_health_changed.connect(_sonar_health_changed)

func _ballast_health_changed():
	ballast_health.value = GameState.ballast_health

func _boiler_health_changed():
	boiler_health.value = GameState.boiler_health

func _circuit_health_changed():
	circuit_health.value = GameState.circuit_health

func _sonar_health_changed():
	sonar_health.value = GameState.sonar_health

func _on_texture_button_pressed() -> void:
	terminal_closed.emit()
