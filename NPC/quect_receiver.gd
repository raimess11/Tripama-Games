extends NPC
class_name QuestReceiver

@onready var complete_quest = $Action/CompleteQuestAction

func _ready():
	dialogue = load_dialogue()
	dialogue_index = -1
	self.connect("finished_Chatting", _On_finished_chatting)

#Finish quest when chatting is finished
func _On_finished_chatting():
	print("Finished chatting")
	complete_quest.deliver_Quest()

