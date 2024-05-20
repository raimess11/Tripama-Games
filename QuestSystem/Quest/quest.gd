extends Node
class_name Quest

signal started()
signal completed()
signal delivered()

@onready var objectives = $Objective

@export var title : String
@export var description : String

func _start():
	#Start the quest
	
	for objective in objectives:
		#Connect signal with function
		objective.connect("completed", _on_Objective_completed)
	emit_signal("started")

func get_objective():
	#Return all objective
	return objectives.get_children()

func get_completed_objectives():
	#Return all completed objectives
	var completed : Array = []
	for objective in get_objective():
		if not objective.objective_completed:
			continue
		completed.append(objective)
	return completed

func _on_Objective_completed(objective) -> void:
	if get_completed_objectives().size() == get_objective().size():
		emit_signal("completed")

func _deliver():
	emit_signal("delivered")

