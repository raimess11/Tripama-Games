extends Level

@onready var cut_scene = $CutScene

const Balloon_source = preload("res://NPC/DialogueSystem/Bubble/balloon.tscn")
@export var dialogue_resource : DialogueResource

func _ready():
	QuestSystem.connectAllNodes()
	NpcState.has_interacted.connect(_update_doors)
	addDoorToDoors()
	connect_NPC_to_player()
	player.disable()
	player.visible = false
	
	if data == null:
		enter_level()
	
	$Overlay.visible = false
	nextCutscene("start_description")
	TextTransition.transisition("s3desc1")
	await TextTransition.TextTransitionEnd
	start_intro()
	$Overlay.visible = true
	DialogueManager.dialogue_ended.connect(_on_Dialogue_Ended)

func nextCutscene(next_scene):
	cut_scene.play(next_scene)

func _on_Dialogue_Ended(source):
	if source == dialogue_resource:
		$Overlay.visible = false
		TextTransition.transisition("s3desc2")
		nextCutscene("next_description")

func start_intro():
	var balloon : Node = Balloon_source.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, "start")



func _on_cut_scene_animation_finished(anim_name):
	if anim_name == "next_description":
		await TextTransition.TextTransitionEnd
		$Overlay.visible = true
		nextCutscene("end")
