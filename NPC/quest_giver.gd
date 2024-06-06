extends NPC
class_name QuestGiver

@onready var giveQuest = $Action/GiveQuestAction


func _ready():
	dialogue = load_dialogue()
	dialogue_index = -1
	self.connect("finished_Chatting", _On_finished_chatting)

#Give quest when finished chatting
func _On_finished_chatting():
	print("Finished chatting")
	giveQuest.give_Quest()

