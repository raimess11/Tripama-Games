extends QuestObjective
class_name QuestInteractObjective

@export var amount : int
@export var npcType : String

var firstAmount : int
func _ready():
	firstAmount = amount
	connect_signals()

#Connect all signals to the correct NPC
func connect_signals() -> void:
	for npc in get_tree().get_nodes_in_group(npcType):
		if not npc.interacted.is_connected(_on_NPC_interacted):
			npc.connect("interacted", _on_NPC_interacted.bind(npc))

#Update quest on interacted NPC
func _on_NPC_interacted(npc):
	amount -= 1
	emit_signal("updated")
	if amount == 0 and not objective_completed:
		finish()

#Return the string verstion of the quest
func as_text() -> String:
	return "Interacted %s (%s) %s" %  [str(firstAmount - amount), npcType, "completed" if objective_completed else ""]
	
