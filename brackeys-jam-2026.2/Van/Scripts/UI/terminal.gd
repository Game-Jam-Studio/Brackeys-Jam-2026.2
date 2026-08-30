extends Control

signal terminal_closed

@onready var ballast_label: ProgressBar = %BallastHealth
@onready var boiler_label: ProgressBar = %BoilerHealth
@onready var sonar_label: ProgressBar = %SonarHealth
@onready var circuit_label: ProgressBar = %CircuitHealth


func _ready() -> void:
	# Connect to the individual subsystem health signals in GameState
	GameState.ballast_health_changed.connect(_on_ballast_changed)
	GameState.boiler_health_changed.connect(_on_boiler_changed)
	GameState.sonar_health_changed.connect(_on_sonar_changed)
	GameState.circuit_health_changed.connect(_on_circuit_changed)
	
	# Initialize the UI using the current variable values in GameState
	_on_ballast_changed(GameState.ballast_health)
	_on_boiler_changed(GameState.boiler_health)
	_on_sonar_changed(GameState.sonar_health)
	_on_circuit_changed(GameState.circuit_health)


func _on_ballast_changed(new_health: float) -> void:
	%BallastHealth.value = new_health


func _on_boiler_changed(new_health: float) -> void:
	%BoilerHealth.value = new_health


func _on_sonar_changed(new_health: float) -> void:
	%SonarHealth.value = new_health


func _on_circuit_changed(new_health: float) -> void:
	%CircuitHealth.value = new_health


func _on_texture_button_pressed() -> void:
	terminal_closed.emit()
