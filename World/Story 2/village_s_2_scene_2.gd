extends Level

const Balloon_source = preload("res://NPC/DialogueSystem/Bubble/balloon.tscn")

@onready var cut_scene = $CutScene
@export var dialogue_resource : DialogueResource
@export var dialogue_resource_p2 : DialogueResource

func _ready():
	QuestSystem.connectAllNodes()
	NpcState.has_interacted.connect(_update_doors)
	addDoorToDoors()
	connect_NPC_to_player()
	player.disable()
	player.visible = false
	
	if data == null:
		enter_level()
	if NpcState.desa_scene2:
		nextCutscene("normal")
	else:
		nextCutscene("start_cutscene")
	
	DialogueManager.dialogue_ended.connect(_on_Dialogue_Ended)

func nextCutscene(next_scene):
	cut_scene.play(next_scene)

func _on_Dialogue_Ended(source):
	if source == dialogue_resource:
		nextCutscene("cutscene_p2")
		player.is_chatting = true
	if source == dialogue_resource_p2:
		player._on_finished_chatting()

func start_intro():
	var balloon : Node = Balloon_source.instantiate()
	get_tree().current_scene.add_child(balloon)
	player.is_chatting = true
	balloon.start(dialogue_resource, "start")

func start_intro_p2():
	var balloon : Node = Balloon_source.instantiate()
	get_tree().current_scene.add_child(balloon)
	player.is_chatting = true
	balloon.start(dialogue_resource_p2, "start")
