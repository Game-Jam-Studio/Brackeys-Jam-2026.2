extends Node

# How often (in seconds) the game checks to see if a system breaks
@export var tick_rate: float = 5.0 

# Chance of breaking at 100% health
@export var min_breakdown_chance: float = 0.1 

# Chance of breaking at 0% health
@export var max_breakdown_chance: float = 0.8 

const ALL_SYSTEMS: Array[String] = ["Ballast", "Boiler", "Sonar", "Circuit"]


func _ready() -> void:
	# Create & start the recurring breakdown check timer
	var timer = Timer.new()
	timer.wait_time = tick_rate
	timer.autostart = true
	timer.timeout.connect(_on_breakdown_tick)
	add_child(timer)


func _on_breakdown_tick() -> void:
	# Block breakdowns if a system is broken or player is currently in a minigame
	if GameState.get_broken_count() > 0 or not GameState.active_repairs.is_empty():
		return
	
	var health_ratio: float = GameState.ship_health / GameState.MAX_SHIP_HEALTH
	var current_chance: float = lerp(max_breakdown_chance, min_breakdown_chance, health_ratio)
	
	var roll: float = randf()
	print("Roll: ", roll, " | Threshold: ", current_chance)
	
	if roll <= current_chance:
		_trigger_breakdown()


func _is_any_system_broken() -> bool:
	return GameState.is_ballast_broken or GameState.is_boiler_broken or GameState.is_sonar_broken or GameState.is_circuit_broken


func _trigger_breakdown() -> void:
	# Create a randomized copy so it inspects systems in a different order each time, avoiding immediate repeats
	var candidate_pool = ALL_SYSTEMS.duplicate()
	candidate_pool.shuffle()

	for candidate in candidate_pool:
		if not GameState.can_system_break(candidate):
			continue
		
		GameState.set_system_broken(candidate, true)
		print("System Broken: ", candidate)
		return
