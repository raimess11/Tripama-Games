extends Node
class_name CompleteQuestAction

@export var quest_reference : PackedScene
var quest : Quest = null
var active : bool = true

func _ready():
	assert(quest_reference)
	quest = QuestSystem.findComplete(quest_reference.instantiate())
	quest.connect("completed", _On_Quest_completed)

func _On_Quest_completed():
	active = false

func deliver_Quest() -> void:
	if not active:
		active = true
		return
	if not QuestSystem.isCompleted(quest):
		return
	QuestSystem.deliver(quest)
