extends Level

@onready var cut_scene = $CutScene

const Balloon_source = preload("res://NPC/DialogueSystem/Bubble/balloon.tscn")
@export var dialogue_resource : DialogueResource
@export var dialogue_resourceV2 : DialogueResource
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
	if NpcState.forest_scene1 and NpcState.forest2_scene1:
		nextCutscene("Normal")
	else:
		nextCutscene("start_intro")
	DialogueManager.dialogue_ended.connect(_on_Dialogue_Ended)

func nextCutscene(next_scene):
	cut_scene.play(next_scene)

func _on_Dialogue_Ended(source):
	if source == dialogue_resource:
		nextCutscene("bush_move")
	if source == dialogue_resourceV2:
		nextCutscene("end_first_intro")
	if source == dialogue_resource_p2:
		nextCutscene("end_last_intro")

func start_intro():
	var balloon : Node = Balloon_source.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, "start")

func continue_intro():
	var balloon : Node = Balloon_source.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resourceV2, "start2")

func start_intro_p2():
	var balloon : Node = Balloon_source.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource_p2, "start")

