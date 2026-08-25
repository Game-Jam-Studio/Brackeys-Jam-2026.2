extends Node

@export var noteObjectToSpawn: PackedScene
@export var spawnTargets: Array[Node2D]
@export var noteDestinations: Array[Node2D]
@export var spawnTimes: Array[float]
@export var timer: Timer

var currNoteSpawned = 0
var errorCount = 0

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
		
		#WARNING this will print at the time the last note spawns so more errors 
		# could still come and this is just a placeholder
		print("error count: " + str(errorCount))
		return
	timer.start(spawnTimes[currNoteSpawned])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
