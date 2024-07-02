extends Level

const Balloon_source = preload("res://NPC/DialogueSystem/Bubble/balloon.tscn")

@onready var cut_scene = $CutScene
@onready var villager_1 = $S1IntroVil1
@onready var villager_2 = $S1IntroVil2

@export var dialogue_resource : DialogueResource

func _ready():
	QuestSystem.connectAllNodes()
	NpcState.has_interacted.connect(_update_doors)
	addDoorToDoors()
	player.disable()
	player.visible = false
	DialogueManager.dialogue_ended.connect(_on_Dialogue_Ended)
	
	if data == null:
		enter_level()
	nextCutscene("PlayerDialogue")
	
	villager_1.chat_ends.connect(nextCutscene.bind("finishedCutscene"))
	villager_2.chat_ends.connect(nextCutscene.bind("finishedCutscene"))

func nextCutscene(next_scene):
	cut_scene.play(next_scene)

func _on_Dialogue_Ended(source):
	if source == dialogue_resource:
		nextCutscene("PlayerDialogueEnd")

func start_intro():
	var balloon : Node = Balloon_source.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, "start")
	#DialogueManager.show_example_dialogue_balloon(dialogue_resource, "test")
