extends QuestObjective
class_name QuestInteractObjective

@export var amount : int
@export var npcType : String

func connect_signals() -> void:
	for npc in get_tree().get_nodes_in_group(npcType):
		npc.connect("interacted", _on_NPC_interacted)

func _on_NPC_interacted(npc):
	amount -= 1
	emit_signal("updated")
	if amount == 0 and not objective_completed:
		finish()
func as_text() -> String:
	return "Interacted %s (%s) %s" %  [str(amount), npcType, "completed" if objective_completed else ""]
	
