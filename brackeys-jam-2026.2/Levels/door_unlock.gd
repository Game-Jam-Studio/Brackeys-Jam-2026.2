class_name DoorUnlockTrigger
extends Area3D

@export var doors_to_unlock: Array[Node3D] = []

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		for door in doors_to_unlock:
			if door.has_method("unlock"):
				door.unlock()
			elif door.has_node("DoorTrigger"):
				door.get_node("DoorTrigger").unlock()
		queue_free()
