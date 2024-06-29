extends Level

const Balloon_source = preload("res://NPC/DialogueSystem/Bubble/balloon.tscn")

@onready var cut_scene = $CutScene

@export var dialogue_resource : DialogueResource

# Called when the node enters the scene tree for the first time.
func _ready():
	QuestSystem.connectAllNodes()
	addDoorToDoors()
	player.disable()
	player.visible = false
	DialogueManager.dialogue_ended.connect(_on_Dialogue_Ended)
	
	if data == null:
		enter_level()
	nextCutscene("start_kuliah")

func nextCutscene(next_scene):
	cut_scene.play(next_scene)

func _on_Dialogue_Ended(source):
	print("Dialogue end")
	if source == dialogue_resource:
		nextCutscene("end_kuliah")

func start_intro():
	var balloon : Node = Balloon_source.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, "start")
