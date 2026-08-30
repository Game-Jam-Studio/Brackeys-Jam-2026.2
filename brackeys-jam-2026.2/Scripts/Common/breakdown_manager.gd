extends Node

# How often (in seconds) the game checks to see if a system breaks
@export var tick_rate: float = 5.0 

# Chance of breaking at 100% health
@export var min_breakdown_chance: float = 0.1 

# Chance of breaking at 0% health
@export var max_breakdown_chance: float = 0.8 

const ALL_SYSTEMS: Array[String] = ["Ballast", "Boiler", "Sonar", "Circuit"]
var system_pool: Array[String] = []


func _ready() -> void:
	_refill_pool()
	
	# Create & start the recurring breakdown check timer
	var timer = Timer.new()
	timer.wait_time = tick_rate
	timer.autostart = true
	timer.timeout.connect(_on_breakdown_tick)
	add_child(timer)


func _refill_pool() -> void:
	system_pool = ALL_SYSTEMS.duplicate()
	system_pool.shuffle()


func _on_breakdown_tick() -> void:
	var health_ratio: float = GameState.ship_health / GameState.MAX_SHIP_HEALTH
	var current_chance: float = lerp(max_breakdown_chance, min_breakdown_chance, health_ratio)
	
	# Generate a random float between 0.0 and 1.0
	var roll: float = randf()
	
	if roll <= current_chance:
		_trigger_breakdown()


func _trigger_breakdown() -> void:
	var attempts: int = 0
	
	# Loop until we find a valid unbroken system or exhaust all options
	while attempts < ALL_SYSTEMS.size():
		if system_pool.is_empty():
			_refill_pool()
			
		var candidate: String = system_pool.pop_front()
		var is_broken: bool = false
		
		# Check the current status directly from GameState
		match candidate:
			"Ballast": is_broken = GameState.is_ballast_broken
			"Boiler": is_broken = GameState.is_boiler_broken
			"Sonar": is_broken = GameState.is_sonar_broken
			"Circuit": is_broken = GameState.is_circuit_broken
			
		if not is_broken:
			GameState.set_system_broken(candidate, true)
			# Placeholder for P0 HUD alert integration
			print("System Broken: ", candidate)
			return
			
		attempts += 1
