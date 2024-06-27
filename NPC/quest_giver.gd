extends NPC
class_name QuestGiver

@onready var giveQuest = $Action/GiveQuestAction
@export var questStory : int = 0
@export var questKey : String = ""


func _ready():
	actionable.connect("dialogueEnds", _On_finished_chatting)
	actionable.connect("dialogueEnds", _on_Dialogue_ends)

#Give quest when finished chatting
func _On_finished_chatting():
	print("Finished chatting")
	if NpcState.questNPC[questStory][questKey]:
		giveQuest.give_Quest()

