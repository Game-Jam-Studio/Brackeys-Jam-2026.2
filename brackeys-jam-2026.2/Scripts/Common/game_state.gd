extends Node

# Emitted whenever the submarine's health value changes
signal ship_health_changed(new_health: float)

# Signals for individual subsystems
signal ballast_health_changed(new_health: float)
signal boiler_health_changed(new_health: float)
signal sonar_health_changed(new_health: float)
signal circuit_health_changed(new_health: float)

# Maximum hit points for the submarine
const MAX_SHIP_HEALTH: float = 100.0

# Current ship health; updates clamp the value and emit the signal
var ship_health: float = 100.0:
	set(value):
		ship_health = clamp(value, 0.0, MAX_SHIP_HEALTH)
		ship_health_changed.emit(ship_health)
