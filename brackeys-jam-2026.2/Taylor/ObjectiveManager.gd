extends Node

signal trigger_objective_dialogue(line_id: String)
signal objective_updated(objective_name: String)
signal objective_tier_changed(tier: int)
signal set_display_visible(is_visible: bool)

enum ObjectiveState { INTRO, AREA_1, AREA_2, AREA_3_LOOP, ESCAPE }
var current_state: ObjectiveState = ObjectiveState.INTRO
var minigames_played_count: int = 0
var area_3_completion_count: int = 0
const AREA_3_REQUIRED_LOOPS: int = 2


func _ready() -> void:
	pass


func record_minigame_played() -> void:
	if current_state == ObjectiveState.INTRO:
		minigames_played_count += 1
		if minigames_played_count >= 1:
			print("Intro complete! Showing objectives.")
			current_state = ObjectiveState.AREA_1
			emit_signal("objective_updated", "Insert a Power Cell into the Area 2 Door.")
			emit_signal("trigger_objective_dialogue", "Obj-Intro-Complete")
			emit_signal("objective_tier_changed", 1)
			emit_signal("set_display_visible", true)

func complete_intro() -> void:
	if current_state == ObjectiveState.INTRO:
		current_state = ObjectiveState.AREA_1
		emit_signal("objective_updated", "Insert a Power Cell into the Area 2 Door.")
		emit_signal("trigger_objective_dialogue", "Obj-Intro-Complete")
		emit_signal("objective_tier_changed", 1)
		emit_signal("set_display_visible", true)

func unlock_area_2() -> void:
	current_state = ObjectiveState.AREA_2
	emit_signal("objective_updated", "Add Oil to the hinges of my Area 3 door.")
	emit_signal("trigger_objective_dialogue", "Obj-Area2-Unlock")
	emit_signal("objective_tier_changed", 2)


func unlock_area_3() -> void:
	current_state = ObjectiveState.AREA_3_LOOP
	area_3_completion_count = 0
	emit_signal("objective_updated", "Feed Me.")
	emit_signal("trigger_objective_dialogue", "Obj-Area3-Unlock")
	emit_signal("objective_tier_changed", 3)


func unlock_area_4() -> void:
	if current_state == ObjectiveState.AREA_3_LOOP:
		area_3_completion_count += 1
		if area_3_completion_count >= AREA_3_REQUIRED_LOOPS:
			current_state = ObjectiveState.ESCAPE
			emit_signal("objective_updated", "Escape from the Exit Door in Area 1.")
			emit_signal("trigger_objective_dialogue", "Obj-Escape-Ready")
		else:
			emit_signal("objective_updated", "Feed Me. (" + str(area_3_completion_count) + "/" + str(AREA_3_REQUIRED_LOOPS) + ")")
