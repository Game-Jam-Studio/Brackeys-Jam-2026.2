extends Control

const UI_ACCEPT = preload("uid://ci0u00xywksjx")
const UI_ERROR = preload("uid://44cjuy6hy1ge")
const UI_DIAL_SHORT = preload("uid://f5we04nn8mkj")

@export_category("Textures")
@export var single_sprite: bool
## Texture for Wires
@export var wire_end_texture: Texture

@export var wire_middle_texture: Texture
## Texture for Slots
@export var slot_textures: Array[Texture2D]

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
var is_finished: bool = false

var position_ints: Array[int]
var slot_ints: Array[int]
var wire_array: Array[TextureRect]
var wire_starts: Array[TextureRect]
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
	
	#Set wire start array
	for wire in $WireStarts.get_children():
		wire_starts.append(wire)
	
	#Set slot array to all slots
	for slot in $Slots.get_children():
		slot_array.append(slot)
		position_ints.append(slot_array.size() - 1)
		slot_ints.append(slot_array.size() - 1)
	
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
	#if single_sprite:
	#	for wire in range(wire_array.size()):
	#		wire_array[wire].modulate = Color(wire * .75 + 0.25, wire * .75 + 0.25, wire * .75 + 0.25, 1)
	#else:
	#	for wire in range(wire_array.size()):
	#		wire_array[wire].get_child(1).texture = wire_end_texture
	
	#Set the color of all slots
	#if single_sprite:
	#	for slot in range(slot_array.size()):
	#		slot_array[slot].modulate = Color(slot * .75 + 0.25, slot * .75 + 0.25, slot * .75 + 0.25, 1)
	#else:
	#	for slot in range(wire_array.size()):
	#		slot_array[slot].texture = slot_textures[slot]
	#		wire_starts[slot].texture = slot_textures[slot]
	
	slot_textures = ProgressionManager.get_circuit_slots()
	wire_middle_texture = ProgressionManager.get_asset_texture("circuit", "wire_middle")
	wire_end_texture = ProgressionManager.get_asset_texture("circuit", "wire_end")
	
	# Set the color/texture of all wires
	if single_sprite:
		for wire in range(wire_array.size()):
			wire_array[wire].modulate = Color(wire * .75 + 0.25, wire * .75 + 0.25, wire * .75 + 0.25, 1)
	else:
		for wire in range(wire_array.size()):
			wire_array[wire].get_child(1).texture = wire_end_texture
			# If your wire script also needs the middle texture assignment, apply it here:
			if wire_array[wire].has_node("MiddleSprite"):
				wire_array[wire].get_node("MiddleSprite").texture = wire_middle_texture
	
	# Set the texture of all slots
	if single_sprite:
		for slot in range(slot_array.size()):
			slot_array[slot].modulate = Color(slot * .75 + 0.25, slot * .75 + 0.25, slot * .75 + 0.25, 1)
	else:
		for slot in range(wire_array.size()):
			if slot < slot_textures.size():
				slot_array[slot].texture = slot_textures[slot]
				wire_starts[slot].texture = slot_textures[slot]
	
	#Shuffle arrays
	position_ints.shuffle()
	slot_ints.shuffle()


	#Set positions of all wires
	for wire in range(wire_array.size()):
		wire_array[position_ints[wire]].position = wire_locations[position_ints[wire]].position - wire_array[position_ints[wire]].size / 2
		wire_starts[position_ints[wire]].position.y = wire_locations[position_ints[wire]].position.y - wire_array[position_ints[wire]].size.y / 2
	
	#Set positions of all slots
	for slot in range(slot_array.size()):
		slot_array[slot_ints[slot]].position = slot_locations[slot].position - slot_array[slot].size / 2
	
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
	if is_finished:
		return
		
	if wire_ID == slot_ID:
		amount_correct += 1
	else:
		is_finished = true
		%AudioStreamPlayer.pitch_scale = 1
		%AudioStreamPlayer.stream = UI_ERROR
		%AudioStreamPlayer.play()
		minigame_completed.emit(false)
		await get_tree().create_timer(1).timeout
		queue_free()
		return
	
	if connections == required_correct and not is_finished:
		is_finished = true
		%AudioStreamPlayer.pitch_scale = 1
		minigame_completed.emit(true)
		%AudioStreamPlayer.stream = UI_ACCEPT
		%AudioStreamPlayer.play()
		await get_tree().create_timer(1).timeout
		queue_free()
