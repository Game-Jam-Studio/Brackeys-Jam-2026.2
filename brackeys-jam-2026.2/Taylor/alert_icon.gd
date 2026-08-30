extends TextureRect

func _ready() -> void:
	# Create a tween bound to this node and set it to loop infinitely
	var tween = create_tween().set_loops()
	
	# Tween the alpha channel down to 20% opacity over 1.0 second
	tween.tween_property(self, "self_modulate:a", 0.2, 1.0)
	
	# Tween the alpha channel back up to 100% opacity over 1.0 second
	tween.tween_property(self, "self_modulate:a", 1.0, 1.0)
