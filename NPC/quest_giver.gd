extends NPC
class_name QuestGiver

@onready var giveQuest = $Action/GiveQuestAction
@export var questStory : int = 0
@export var questKey : String = ""


func _ready():
	actionable.connect("dialogueEnds", _On_finished_chatting)
	actionable.connect("dialogueEnds", _on_Dialogue_ends)
	actionable.connect("dialogueStart", _on_Dialogue_start)

#Give quest when finished chatting
func _On_finished_chatting():
	print("Finished chatting")
	if NpcState.questNPC[questStory][questKey]:
		giveQuest.give_Quest()

func _on_actionable_area_entered(area):
	label.show()
	
func _on_actionable_area_exited(area):
	label.hide()
