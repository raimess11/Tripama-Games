extends Node
class_name GiveQuestAction

@export var quest_reference : PackedScene
var quest : Quest = null
var active : bool = true

func _ready() -> void:
	assert(quest_reference)
	quest = QuestSystem.findAvailable(quest_reference.instantiate())
	quest.connect("started", _On_Quest_started)

func _On_Quest_started():
	active = false

func give_Quest() -> void:
	if not active:
		active = true
		return
	quest = quest_reference.instantiate()
	if not QuestSystem.isAvailable(quest):
		return
	QuestSystem.start(quest)
