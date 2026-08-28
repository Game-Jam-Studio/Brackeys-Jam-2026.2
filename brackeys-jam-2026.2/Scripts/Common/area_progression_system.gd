extends Node

# [UnlockKeyString] : {List<Door> ToUnlock, TODOAnyOtherProgressionUpdates}
@export var area_progression_dictionary: Dictionary[String, AreaProgressionValue] = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func complete_unlock_key(key: String):
	if key not in area_progression_dictionary:
		print("that unlock key doesn't exist - its probably because adding things to dictionaries in godot is awful")
		print("Make sure you click the Add Key/Value Pair button AFTER entering values")
		return
	for door in area_progression_dictionary[key].doors_to_unlock:
		#TODO add unlock sfx
		door.unlock()
	if area_progression_dictionary[key].area_to_unlock >= 0 :
		#TODO add unlock area sfx
		GameState.unlock_next_area(area_progression_dictionary[key].area_to_unlock)
	#TODO loop through any other changes that are needed for this next progression
