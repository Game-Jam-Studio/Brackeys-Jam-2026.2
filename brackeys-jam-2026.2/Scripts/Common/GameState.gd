extends Node

# BEWARE if we use these types of signals, we need to be careful since we might have a 
# minigame set the value while the object listening for the value in the submarine
# scene isn't currently loaded
signal example_ship_deterioration_changed(new_deterioration: float)

const example_max_ship_health: float = 100

var example_ship_deterioration: float = 100:
	set(value):
		example_ship_deterioration = clamp(value, 0, example_max_ship_health)
		example_ship_deterioration_changed.emit(example_ship_deterioration)
