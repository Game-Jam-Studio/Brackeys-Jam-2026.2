extends Control

const UI_ACCEPT = preload("uid://ci0u00xywksjx")
const UI_ERROR = preload("uid://44cjuy6hy1ge")
const UI_DIAL_SHORT = preload("uid://f5we04nn8mkj")


#@export var align_horizontally: bool
signal minigame_completed(success: bool)

var amount_correct: int
var required_correct: int
var connections: int

var wire_array: Array[TextureRect]
var slot_array: Array[TextureRect]
var slot_locations: Array[Node2D]
var wire_locations: Array[Node2D]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%AudioStreamPlayer.pitch_scale = 2
	%AudioStreamPlayer.stream = UI_DIAL_SHORT
#Set wire array to all wires
	for wire in $Wires.get_children():
		wire_array.append(wire)

#Set wire location array to all wire locations
	for location in $WireLocations.get_children():
		wire_locations.append(location)

#Set slot array to all slots
	for slot in $Slots.get_children():
		slot_array.append(slot)

#Set amount of required correct connections
	required_correct = slot_array.size()

#Set slot location array to all slot locations
	for location in $SlotLocations.get_children():
		slot_locations.append(location)

#Set the ID of all wires
	for wire in range(wire_array.size()):
		wire_array[wire].wire_ID = wire

#Set the ID of all slots
	for slot in range(slot_array.size()):
		slot_array[slot].slot_ID = slot

#Set the color of all wires
	for wire in range(wire_array.size()):
		wire_array[wire].modulate = Color(wire * .75 + 0.25, wire * .75 + 0.25, wire * .75 + 0.25, 1)

#Set the color of all slots
	for slot in range(slot_array.size()):
		slot_array[slot].modulate = Color(slot * .75 + 0.25, slot * .75 + 0.25, slot * .75 + 0.25, 1)

#Shuffle arrays
	wire_array.shuffle()
	slot_array.shuffle()

#Set positions of all wires
	for wire in range(wire_array.size()):
		wire_array[wire].position = wire_locations[wire].position - wire_array[wire].size / 2

#Set positions of all slots
	for slot in range(slot_array.size()):
		slot_array[slot].position = slot_locations[slot].position - slot_array[slot].size / 2

#Enable colision detection on all slots
	for slot in slot_array:
		slot.get_child(0).monitoring = true


func _on_slot_wire_connected(wire_ID: int, slot_ID: int) -> void:
	if wire_ID == slot_ID:
		amount_correct += 1
	connections += 1
	%AudioStreamPlayer.play()
	_check_answers()

func _on_slot_2_wire_connected(wire_ID: int, slot_ID: int) -> void:
	if wire_ID == slot_ID:
		amount_correct += 1
	connections += 1
	%AudioStreamPlayer.play()
	_check_answers()

func _on_slot_3_wire_connected(wire_ID: int, slot_ID: int) -> void:
	if wire_ID == slot_ID:
		amount_correct += 1
	connections += 1
	%AudioStreamPlayer.play()
	_check_answers()

func _on_slot_4_wire_connected(wire_ID: int, slot_ID: int) -> void:
	if wire_ID == slot_ID:
		amount_correct += 1
	connections += 1
	%AudioStreamPlayer.play()
	_check_answers()

func _check_answers():
	await get_tree().create_timer(0.1).timeout
	if connections == required_correct:
		if amount_correct == required_correct:
			%AudioStreamPlayer.pitch_scale = 1
			minigame_completed.emit(true)
			%AudioStreamPlayer.stream = UI_ACCEPT
			%AudioStreamPlayer.play()
			await get_tree().create_timer(1).timeout
			queue_free()
		else:
			%AudioStreamPlayer.pitch_scale = 1
			minigame_completed.emit(false)
			%AudioStreamPlayer.stream = UI_ERROR
			%AudioStreamPlayer.play()
			await get_tree().create_timer(1).timeout
			queue_free()
	
