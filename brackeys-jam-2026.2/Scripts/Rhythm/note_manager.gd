class_name NoteManager
extends Node

# Emitted on outcome so the caller can return the camera and call end_repair() on the trigger.
signal minigame_completed(success: bool)

@export var noteObjectToSpawn: PackedScene
@export var spawnTargets: Array[Node2D]
@export var noteDestinations: Array[Node2D]
@export var spawnTimes: Array[float]
@export var timer: Timer

var currNoteSpawned = 0
var errorCount = 0

# Error limit to pass the repair
@export var max_allowed_errors: int = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start(spawnTimes[0])
	timer.timeout.connect(_on_next_note_time)
	pass # Replace with function body.

func _on_next_note_time() -> void:
	var noteNumToSpawn = randi_range(0, 3)
	var spawnedNote = noteObjectToSpawn.instantiate()
	spawnedNote.global_position = spawnTargets[noteNumToSpawn].global_position
	spawnedNote.destination = noteDestinations[noteNumToSpawn].global_position
	spawnedNote.initialize(noteNumToSpawn)
	add_child(spawnedNote)
	
	currNoteSpawned += 1
	if currNoteSpawned == len(spawnTimes):
		timer.stop()
		
		# Allow the final note to reach the destination line
		# The actual value required here for this would be the distance from 
		# spawn to destination over the configured speed in note prefab, 
		# but for the jam, we will just hardcode this
		await get_tree().create_timer(3.25).timeout
		
		# Emit outcome to level manager
		var success: bool = errorCount <= max_allowed_errors
		minigame_completed.emit(success)
		#WARNING this will print at the time the last note spawns so more errors 
		# could still come and this is just a placeholder
		#print("error count: " + str(errorCount))
		return
	timer.start(spawnTimes[currNoteSpawned])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
