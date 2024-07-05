extends Level

@onready var cut_scene = $CutScene
const Balloon_source = preload("res://NPC/DialogueSystem/Bubble/balloon.tscn")
@export var dialogue_resource : DialogueResource

var scene_description1 = "Dengan kesaktian, Ramacandra menyerbu tanah Alengka agar dapat mengembalikan Sinta"
var scene_description2 = "Dengan panah sakti, Rama menebas tangan Kumbakarna. Setelah itu kakinya. Kumbakarna jatuh mengguling-guling. \nMerasa iba dengan raksasa yang lumpuh, Rama melepaskan panah bernama Indrasatra untuk mengakhiri hidup sang raksasa."

func _ready():
	QuestSystem.connectAllNodes()
	NpcState.has_interacted.connect(_update_doors)
	addDoorToDoors()
	connect_NPC_to_player()
	player.disable()
	player.visible = false
	
	if data == null:
		enter_level()
	nextCutscene("first_description")
	
	player.is_chatting = true
	DialogueManager.dialogue_ended.connect(_on_Dialogue_Ended)

func nextCutscene(next_scene):
	cut_scene.play(next_scene)

func _on_Dialogue_Ended(source):
	if source == dialogue_resource:
		nextCutscene("temp_battle")

func start_intro():
	var balloon : Node = Balloon_source.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, "start")


func _on_cut_scene_animation_finished(anim_name):
	if anim_name == "arrow_cutscene":
		nextCutscene("end")
	if anim_name == "temp_battle":
		nextCutscene("arrow_cutscene")
