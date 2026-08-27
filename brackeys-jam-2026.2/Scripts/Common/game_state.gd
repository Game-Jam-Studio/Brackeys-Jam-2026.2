extends Node

signal area_unlocked(new_level: int)

# Emitted whenever the submarine's health value changes
signal ship_health_changed(new_health: float)

# Signals for individual subsystems
signal ballast_health_changed(new_health: float)
signal boiler_health_changed(new_health: float)
signal sonar_health_changed(new_health: float)
signal circuit_health_changed(new_health: float)
signal ship_destroyed

# Damage to ship health per second when broken
@export var damage_per_second: float = 2 # set to 10 for testing
@export var repair_fail_penalty: float = 15.0

const MAX_SHIP_HEALTH: float = 100.0
const MAX_SYSTEM_HEALTH: float = 100.0

var current_area_level: int = 1
var is_ballast_broken: bool = false
var is_boiler_broken: bool = false
var is_sonar_broken: bool = false
var is_circuit_broken: bool = false

var ship_health: float = 100.0:
	set(value):
		ship_health = clampf(value, 0.0, MAX_SHIP_HEALTH)
		ship_health_changed.emit(ship_health)
		if ship_health <= 0.0:
			ship_destroyed.emit()


# Subsystem health
var ballast_health: float = 100.0:
	set(value):
		ballast_health = clampf(value, 0.0, MAX_SYSTEM_HEALTH)
		ballast_health_changed.emit(ballast_health)

var boiler_health: float = 100.0:
	set(value):
		boiler_health = clampf(value, 0.0, MAX_SYSTEM_HEALTH)
		boiler_health_changed.emit(boiler_health)

var sonar_health: float = 100.0:
	set(value):
		sonar_health = clampf(value, 0.0, MAX_SYSTEM_HEALTH)
		sonar_health_changed.emit(sonar_health)

var circuit_health: float = 100.0:
	set(value):
		circuit_health = clampf(value, 0.0, MAX_SYSTEM_HEALTH)
		circuit_health_changed.emit(circuit_health)

func _process(delta: float) -> void:
	var broken_count: int = 0
	if is_ballast_broken:
		broken_count += 1
	if is_boiler_broken:
		broken_count += 1
	if is_sonar_broken:
		broken_count += 1
	if is_circuit_broken:
		broken_count += 1
	
	if broken_count > 0 and ship_health > 0.0:
		ship_health -= broken_count * damage_per_second * delta

func set_system_broken(system_id: String, broken: bool) -> void:
	match system_id:
		"Ballast":
			is_ballast_broken = broken
		"Boiler":
			is_boiler_broken = broken
		"Sonar":
			is_sonar_broken = broken
		"Circuit":
			is_circuit_broken = broken
		_:
			push_error("Unknown system_id: " + system_id)


func take_damage(amount: float) -> void:
	ship_health -= amount


func apply_failure_penalty(system_id: String) -> void:
	print("[GameState] apply_failure_penalty called for: ", system_id)
	# Inflict flat damage penalty to the specific subsystem
	match system_id:
		"Ballast":
			ballast_health -= repair_fail_penalty
		"Boiler":
			boiler_health -= repair_fail_penalty
		"Sonar":
			sonar_health -= repair_fail_penalty
		"Circuit":
			circuit_health -= repair_fail_penalty
		_:
			push_error("Unknown system_id: " + system_id)


func unlock_next_area(level: int) -> void:
	current_area_level = level
	area_unlocked.emit(current_area_level)
