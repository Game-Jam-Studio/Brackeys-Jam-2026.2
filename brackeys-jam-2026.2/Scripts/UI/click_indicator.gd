extends MeshInstance3D

var tween: Tween


func _ready() -> void:
	visible = false


func play_click_ping(world_position: Vector3) -> void:
	# Slight vertical offset above the floor surface to prevent z-fighting
	global_position = world_position + Vector3(0.0, 0.02, 0.0)
	visible = true
	
	if tween and tween.is_running():
		tween.kill()
	
	scale = Vector3(1.0, 1.0, 1.0)
	
	tween = create_tween()
	tween.tween_property(self, "scale", Vector3(0.01, 0.01, 0.01), 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_callback(func(): visible = false)


func update_hold_position(world_position: Vector3) -> void:
	if tween and tween.is_running():
		tween.kill()
	
	global_position = world_position + Vector3(0.0, 0.02, 0.0)
	scale = Vector3(1.0, 1.0, 1.0)
	visible = true


func finish_hold() -> void:
	if not visible: return
	
	if tween and tween.is_running():
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(self, "scale", Vector3(0.01, 0.01, 0.01), 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_callback(func(): visible = false)
	
