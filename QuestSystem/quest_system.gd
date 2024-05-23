extends Node

@onready var available = $Available
@onready var active = $Active
@onready var completed = $Completed
@onready var delivered = $Delivered


func findAvailable(reference : Quest) -> Quest:
	#Return the requested Quest
	return available.find(reference)

func getAvailable() -> Array:
	#Return list of available quest
	return available.getQuest()

func isAvailable(reference : Quest) -> bool:
	#Check if quest is available
	return available.find(reference) != null

func start(reference : Quest):
	var quest : Quest = findAvailable(reference)
	quest.connect("completed", _on_Quest_Completed.bind(quest))
	available.remove_child(quest)
	active.add_child(quest)
	quest._start()

func _on_Quest_Completed(quest):
	active.remove_child(quest)
	completed.add_child(quest)

func deliver(quest : Quest):
	"""
	Mark the quest as complete
	"""
	quest._deliver()
	print(quest.get_parent())
	assert(quest.get_parent() == completed)
	completed.remove_child(quest)
	delivered.add_child(quest)

func findComplete(reference : Quest) -> Quest:
	#Return the requested Quest
	return completed.find(reference)

func getComplete() -> Array:
	#Return list of available quest
	return completed.getQuest()

func isCompleted(reference : Quest) -> bool:
	#Check if quest is available
	return completed.find(reference) != null
