extends NPC
class_name QuestReceiver

@onready var complete_quest = $Action/CompleteQuestAction

@export var questStory : int = 0
@export var questKey : String = ""

func _ready():
	actionable.connect("dialogueEnds", _On_finished_chatting)
	actionable.connect("dialogueEnds", _on_Dialogue_ends)

#Finish quest when chatting is finished
func _On_finished_chatting():
	print("Finished chatting")
	if NpcState.questNPC[questStory][questKey]:
		complete_quest.deliver_Quest()

