"""
Action for the npc to Give reward and complete the
completed quest
"""
extends Node
class_name CompleteQuestAction

@export var quest_reference : PackedScene
var quest : Quest = null
var active : bool = true

func _ready():
	assert(quest_reference)
	#Connect the completed quest with teh function
	if QuestSystem.isCompleted(quest_reference.instantiate()):
		quest = QuestSystem.findComplete(quest_reference.instantiate())
		quest.connect("completed", _On_Quest_completed)
	elif QuestSystem.isAvailable(quest_reference.instantiate()):
		quest = QuestSystem.findAvailable(quest_reference.instantiate())
		quest.connect("completed", _On_Quest_completed)
	elif QuestSystem.isActive(quest_reference.instantiate()):
		quest = QuestSystem.findActive(quest_reference.instantiate())
		quest.connect("completed", _On_Quest_completed)

func _On_Quest_completed():
	active = false

#deliver quest from complete to delivered
func deliver_Quest() -> void:
	if not active:
		active = true
		return
	if not QuestSystem.isCompleted(quest):
		return
	QuestSystem.deliver(quest)
