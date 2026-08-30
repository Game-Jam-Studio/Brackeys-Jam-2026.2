extends AudioStreamPlayer

func _ready() -> void:
	# Listen for system state changes
	GameState.system_state_changed.connect(_on_system_state_changed)

func _on_system_state_changed(_system_id: String, _is_broken: bool) -> void:
	if GameState.get_broken_count() > 0 and not playing:
		play()
	elif GameState.get_broken_count() == 0 and playing:
		stop()
