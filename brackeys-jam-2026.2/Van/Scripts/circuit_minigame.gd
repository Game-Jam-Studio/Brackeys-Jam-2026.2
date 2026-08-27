extends Control

@export var align_horizontally: bool

var wire_array: Array[TextureRect]
var slot_array: Array[TextureRect]
var slot_locations: Array[Node2D]
var wire_locations: Array[Node2D]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#Set wire array to all wires
	for wire in $Wires.get_children():
		wire_array.append(wire)

#Set wire location array to all wire locations
	for location in $WireLocations.get_children():
		wire_locations.append(location)

#Set slot array to all slots
	for slot in $Slots.get_children():
		slot_array.append(slot)

#Set slot location array to all slot locations
	for location in $SlotLocations.get_children():
		slot_locations.append(location)

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
