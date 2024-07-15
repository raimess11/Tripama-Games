extends Level

@onready var villager = $S1_Scene1_Vil1

var battle_companion_path = "res://Battle_System/Story 1/s_1_companion_battle.tscn"
var battle_no_companion_path = "res://Battle_System/Story 1/s_1_no_companion.tscn"

func _ready():
	QuestSystem.connectAllNodes()
	NpcState.has_interacted.connect(_update_doors)
	addDoorToDoors()
	player.disable()
	player.visible = false
	connect_NPC_to_player()
	
	if data == null:
		enter_level()
	
	villager.chat_ends.connect(_on_chat_end)

func _on_chat_end():
	if NpcState.accept_help_S1:
		SceneManager.load_new_scene(battle_companion_path, "fade_to_black")
	else:
		SceneManager.load_new_scene(battle_no_companion_path, "fade_to_black")
