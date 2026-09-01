extends Control

@onready var progress_bar: ProgressBar = $ProgressBar
var progress: Array[float] = []
var scene_name: String
var scene_load_status: int = 0

func _ready() -> void:
	scene_name = GameState.scene_to_load
	ResourceLoader.load_threaded_request(scene_name)

func _process(_delta: float) -> void:
	scene_load_status = ResourceLoader.load_threaded_get_status(scene_name, progress)
	
	match scene_load_status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			var pct = progress[0] * 100
			progress_bar.value = pct
		ResourceLoader.THREAD_LOAD_LOADED:
			var scene = ResourceLoader.load_threaded_get(GameState.scene_to_load)
			get_tree().change_scene_to_packed(scene)
