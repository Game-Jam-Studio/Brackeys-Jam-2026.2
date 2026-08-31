extends Node

# Emitted whenever the submarine's health value changes
signal ship_health_changed(new_health: float)

# Signals for individual subsystems
signal ballast_health_changed(new_health: float)
signal boiler_health_changed(new_health: float)
signal sonar_health_changed(new_health: float)
signal circuit_health_changed(new_health: float)
signal ship_destroyed

# Broadcasts when any system breaks or is repaired
signal system_state_changed(system_id: String, is_broken: bool)

# Damage to ship health per second when broken
@export var damage_per_second: float = 1 # set to 10 for testing
@export var repair_fail_penalty: float = 25.0

const MAX_SHIP_HEALTH: float = 100.0
const MAX_SYSTEM_HEALTH: float = 100.0

var active_repairs: Array[String] = []

var collected_items: Array[String] = []

var current_area_level: int = 1
var is_ballast_broken: bool = false:
	set(value):
		# Only emit if the state actually changes to prevent duplicate triggers
		if is_ballast_broken != value:
			is_ballast_broken = value
			system_state_changed.emit("Ballast", value)

var is_boiler_broken: bool = false:
	set(value):
		if is_boiler_broken != value:
			is_boiler_broken = value
			system_state_changed.emit("Boiler", value)

var is_sonar_broken: bool = false:
	set(value):
		if is_sonar_broken != value:
			is_sonar_broken = value
			system_state_changed.emit("Sonar", value)

var is_circuit_broken: bool = false:
	set(value):
		if is_circuit_broken != value:
			is_circuit_broken = value
			system_state_changed.emit("Circuit", value)

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
	# Retrieve the total broken count from the helper function
	var broken_count = get_broken_count()
	
	if broken_count > 0 and ship_health > 0.0:
		ship_health -= broken_count * damage_per_second * delta


func get_broken_count() -> int:
	# Calculate and return the total number of currently broken systems
	var count: int = 0
	if is_ballast_broken:
		count += 1
	if is_boiler_broken:
		count += 1
	if is_sonar_broken:
		count += 1
	if is_circuit_broken:
		count += 1
	return count


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


# Might be unused? Consider for cleanup
func take_damage(amount: float) -> void:
	ship_health -= amount


func apply_failure_penalty(system_id: String) -> void:
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


func set_system_repairing(system_id: String, is_repairing: bool) -> void:
	if is_repairing and not active_repairs.has(system_id):
		active_repairs.append(system_id)
	elif not is_repairing and active_repairs.has(system_id):
		active_repairs.erase(system_id)


func can_system_break(system_id: String) -> bool:
	# Reject if the player is currently inside the minigame for this system
	if active_repairs.has(system_id):
		return false
	
	# Reject if the system is already broken
	match system_id:
		"Ballast":
			return not is_ballast_broken
		"Boiler":
			return not is_boiler_broken
		"Sonar":
			return not is_sonar_broken
		"Circuit":
			return not is_circuit_broken
		_:
			return false


func collect_item(item_key: String) -> void:
	if not collected_items.has(item_key):
		collected_items.append(item_key)


func has_item(item_key: String) -> bool:
	return collected_items.has(item_key)


func consume_item(item_key: String) -> void:
	if collected_items.has(item_key):
		collected_items.erase(item_key)
