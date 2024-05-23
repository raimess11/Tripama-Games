"""
Quest system API
Used to manage all quest
"""
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

#Start the quest
func start(reference : Quest):
	var quest : Quest = findAvailable(reference) #Get the reference quest
	quest.connect("completed", _on_Quest_Completed.bind(quest)) 
	
	#Move quest from available to active
	available.remove_child(quest) 
	active.add_child(quest)
	quest._start() #Start the quest

func _on_Quest_Completed(quest):
	#When quest complete move from complete to active
	active.remove_child(quest)
	completed.add_child(quest)

func deliver(quest : Quest):
	"""
	Mark the quest as complete
	"""
	quest._deliver()
	assert(quest.get_parent() == completed)
	#Move from completed to delivered
	completed.remove_child(quest)
	delivered.add_child(quest)

func findComplete(reference : Quest) -> Quest:
	#Return the requested Quest
	return completed.find(reference)

func getComplete() -> Array:
	#Return list of completed quest
	return completed.getQuest()

func isCompleted(reference : Quest) -> bool:
	#Check if quest is completed
	return completed.find(reference) != null

func findActive(reference : Quest) -> Quest:
	#Return the requested Quest
	return active.find(reference)

func getActive() -> Array:
	#Return list of active quest
	return active.getQuest()

func isActive(reference : Quest) -> bool:
	#Check if quest is active
	return active.find(reference) != null

#Connect all the quest with the new scene
func connectAllNodes():
	for child in getAvailable():
		child.connectQuestSignal()
		
	for child in getActive():
		child.connectQuestSignal()
		
	for child in getComplete():
		child.connectQuestSignal()
