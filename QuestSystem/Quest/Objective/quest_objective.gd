extends Node
class_name QuestObjective

signal completed(objective)
signal updated(objective)

var objective_completed : bool = false

func finish() -> void:
	objective_completed = true
	emit_signal("completed", self)
