extends Node

# [UnlockKeyString] : {List<Door> ToUnlock, TODOAnyOtherProgressionUpdates}
@export var area_progression_dictionary: Dictionary[String, AreaProgressionValue] = {}

@onready var sfx_player: AudioStreamPlayer3D = $AudioStreamPlayer3D
@export var door_unlocked_sound: AudioStream


func complete_unlock_key(key: String, interacting_door: Door = null):
	print("complete_unlock_key called with key: ", key)
	print("Dictionary keys: ", area_progression_dictionary.keys())
	
	if key not in area_progression_dictionary:
		# print("Unlock key  [", key, "] doesn't exist.")
		return
	
	for door in area_progression_dictionary[key].doors_to_unlock:
		if door == interacting_door:
			door.door_trigger.open_door()  # Open the door the player interacted with
		else:
			door.unlock()  # Just unlock other doors in this group
	
	if area_progression_dictionary[key].area_to_unlock >= 0 :
		sfx_player.stream = door_unlocked_sound
		sfx_player.play()
		ProgressionManager.unlock_next_area(area_progression_dictionary[key].area_to_unlock)
	
	match key:
		"power_cell":
			ObjectiveManager.unlock_area_2()
		"oil":
			ObjectiveManager.unlock_area_3()
		"biomass":
			ObjectiveManager.unlock_area_4()
