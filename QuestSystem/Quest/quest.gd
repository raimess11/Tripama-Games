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
	for objective in objectives.get_children():
		#Connect signal with function
		objective.connect("completed", _on_Objective_completed)
		objective.connect("updated", _on_Objective_updated.bind(objective))
		_on_Objective_updated(objective)
	print("New quest started")
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

#Emit signal when all objective are completed
func _on_Objective_completed(objective) -> void:
	if get_completed_objectives().size() == get_objective().size():
		print("Quest completed")
		emit_signal("completed")

func _deliver():
	print("Quest has been delivered rewards given")
	emit_signal("delivered")

#Delete later
#Print the updated quest
func _on_Objective_updated(objective : QuestObjective):
	print(objective.as_text())

#Connect all objective to the new scene
func connectQuestSignal():
	for objective in get_objective():
		objective.connect_signals()
