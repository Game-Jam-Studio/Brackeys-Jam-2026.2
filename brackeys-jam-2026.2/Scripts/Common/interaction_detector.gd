extends Area3D

# The CharacterBody3D of the player owning this detector
@onready var player: CharacterBody3D = get_parent()

# List of all interactables currently overlapping the player's interaction area
var nearby_interactables: Array[Interactable] = []

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# Connect Area3D overlap signals to track entering and exiting objects
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func _unhandled_input(event: InputEvent) -> void:
	# Listen for an interact action (mapped to 'E' or left-click).
	if event.is_action_pressed("interact"):
		try_interact()


## Finds the closest valid interactable in range and executes its interaction
func try_interact() -> void:
	var target: Interactable = get_closest_interactable()
	
	if target and target.can_interact():
		target.interact(player)
		get_viewport().set_input_as_handled()


## Returns the nearest Interactable from the current overlapping list
func get_closest_interactable() -> Interactable:
	var closest: Interactable = null
	var shortest_distance: float = INF
	
	for interactable in nearby_interactables:
		if not is_instance_valid(interactable):
			continue
		
		var distance: float = global_position.distance_squared_to(interactable.global_position)
		if distance < shortest_distance:
			shortest_distance = distance
			closest = interactable
			
	return closest


func _on_area_entered(area: Area3D) -> void:
	# Only register areas that inherit from our Interactable base class.
	if area is Interactable:
		nearby_interactables.append(area)


func _on_area_exited(area: Area3D) -> void:
	if area is Interactable:
		nearby_interactables.erase(area)
