extends Control

const UI_ACCEPT = preload("uid://ci0u00xywksjx")
const UI_ERROR = preload("uid://44cjuy6hy1ge")
const UI_DIAL_SHORT = preload("uid://f5we04nn8mkj")

@export_category("Textures")
@export var single_sprite: bool
## Texture for Wires
@export var wire_textures: Array[Texture]
## Texture for Slots
@export var slot_textures: Array[Texture]

@export_category("Visual")
## Align wires and slots horizontally to top wire and slot.
@export var align_horizontally: bool
## Align slots vertically to wires.
@export var align_vertically: bool
## Set the widths of the drawn lines for the wires.
@export var wire_width: float = 10

@export_category("Gameplay")
## The distance that the slots will accept the wires from
@export var slot_radius: float = 16

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

	for wire in wire_locations:
		if align_horizontally:
			wire.position.x = wire_locations[0].position.x



#Set slot array to all slots
	for slot in $Slots.get_children():
		slot_array.append(slot)

#Set amount of required correct connections
	required_correct = slot_array.size()

#Set slot location array to all slot locations
	for location in $SlotLocations.get_children():
		slot_locations.append(location)

	for slot in range(slot_locations.size()):
		if align_horizontally:
			slot_locations[slot].position.x = slot_locations[0].position.x
		if align_vertically:
			slot_locations[slot].position.y = wire_locations[slot].position.y

#Set the ID of all wires
	for wire in range(wire_array.size()):
		wire_array[wire].wire_ID = wire

#Set the ID of all slots
	for slot in range(slot_array.size()):
		slot_array[slot].slot_ID = slot

#Set the color of all wires
	if single_sprite:
		for wire in range(wire_array.size()):
			wire_array[wire].modulate = Color(wire * .75 + 0.25, wire * .75 + 0.25, wire * .75 + 0.25, 1)
	else:
		for wire in range(wire_array.size()):
			wire_array[wire].texture = wire_textures[wire]

#Set the color of all slots
	if single_sprite:
		for slot in range(slot_array.size()):
			slot_array[slot].modulate = Color(slot * .75 + 0.25, slot * .75 + 0.25, slot * .75 + 0.25, 1)
	else:
		for slot in range(wire_array.size()):
			slot_array[slot].texture = slot_textures[slot]

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
	connections += 1
	%AudioStreamPlayer.play()
	_check_answers(wire_ID, slot_ID)

func _on_slot_2_wire_connected(wire_ID: int, slot_ID: int) -> void:
	connections += 1
	%AudioStreamPlayer.play()
	_check_answers(wire_ID, slot_ID)

func _on_slot_3_wire_connected(wire_ID: int, slot_ID: int) -> void:
	connections += 1
	%AudioStreamPlayer.play()
	_check_answers(wire_ID, slot_ID)

func _on_slot_4_wire_connected(wire_ID: int, slot_ID: int) -> void:
	connections += 1
	%AudioStreamPlayer.play()
	_check_answers(wire_ID, slot_ID)

func _check_answers(wire_ID, slot_ID):
	await get_tree().create_timer(0.1).timeout
	if wire_ID == slot_ID:
		amount_correct += 1
	else:
		%AudioStreamPlayer.pitch_scale = 1
		%AudioStreamPlayer.stream = UI_ERROR
		%AudioStreamPlayer.play()
		minigame_completed.emit(false)
		await get_tree().create_timer(1).timeout
		queue_free()

	if connections == required_correct:
		%AudioStreamPlayer.pitch_scale = 1
		minigame_completed.emit(true)
		%AudioStreamPlayer.stream = UI_ACCEPT
		%AudioStreamPlayer.play()
		await get_tree().create_timer(1).timeout
		queue_free()
