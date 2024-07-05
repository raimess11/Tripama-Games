extends Level

const Balloon_source = preload("res://NPC/DialogueSystem/Bubble/balloon.tscn")

@export var dialogue_resource : DialogueResource
@export var guard_dialogue : DialogueResource
@onready var cut_scene = $CutScene


func _ready():
	QuestSystem.connectAllNodes()
	NpcState.has_interacted.connect(_update_doors)
	addDoorToDoors()
	player.disable()
	player.visible = false
	
	if data == null:
		enter_level()
	DialogueManager.dialogue_ended.connect(_on_Dialogue_Ended)
	connect_NPC_to_player()
	
	if NpcState.questNPC[0]["questS1Scene1"] == false:
		nextCutscene("fade_to_black")

func _on_Dialogue_Ended(source):
	if source == dialogue_resource:
		nextCutscene("exit")
	if source == guard_dialogue and NpcState.questNPC[0]["questS1Scene2"] == false:
		print("run guard after")
		nextCutscene("fade_to_black")

func nextCutscene(next_scene):
	cut_scene.play(next_scene)

func start_intro():
	var balloon : Node = Balloon_source.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, "start")
	#DialogueManager.show_example_dialogue_balloon(dialogue_resource, "test")


func _on_cut_scene_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		print("play fade")
		cut_scene.play("fade_from_black")
	if anim_name == "fade_from_black":
		print("play base")
		cut_scene.play("base_narator")
