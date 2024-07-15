extends Level

@onready var cut_scene = $CutScene

const Balloon_source = preload("res://NPC/DialogueSystem/Bubble/balloon.tscn")
@export var dialogue_resource : DialogueResource
@onready var audio_pool = $AudioPool
@onready var label = $Overlay/Label

const battle_pandawa = "res://Battle_System/Story 3/s_3_pandawa.tscn"
const battle_kurawa = "res://Battle_System/Story 3/s_3_kurawa.tscn"

const good_end = "Good End \nPandawa dan Korawa berperang sengit di tanah Kurukshetra.\nKarna, yang melihat hancur kerajaannya, mati tanpa memilih sekutu."
const dumb_end = "Dumb End \nPandawa dan Korawa berperang sengit di tanah Kurukshetra.\nKarna berpihak pada Pandawa, menang mengalahkan para Korawa.\nNamun, Arjuna membunuhnya dari belakang. Karna mati dikhianati oleh keluarga aslinya."
const bad_end = "Bad End \nPandawa dan Korawa berperang sengit di tanah Kurukshetra. \nKarna berpihak pada Korawa, bertarung dengan Arjuna.\nNamun, Karna kalah dan terbunuh oleh Arjuna. \nMeskipun mati dalam perang, ia mati dengan hormat dari para Korawa, khususnya Duryodhana."

func _ready():
	QuestSystem.connectAllNodes()
	NpcState.has_interacted.connect(_update_doors)
	addDoorToDoors()
	connect_NPC_to_player()
	player.disable()
	player.visible = false
	
	if data == null:
		enter_level()
	
	DialogueManager.dialogue_ended.connect(_on_Dialogue_Ended)

func nextCutscene(next_scene):
	cut_scene.play(next_scene)

func _on_Dialogue_Ended(source):
	if source == dialogue_resource:
		if NpcState.toForest_choice == "accept":
			SceneManager.load_new_scene(battle_kurawa, "fade_to_black")
		elif NpcState.toForest_choice == "refuse" and NpcState.guardCastle_choice:
			SceneManager.load_new_scene(battle_pandawa, "fade_to_black")
		elif NpcState.toForest_choice == "refuse" and !NpcState.guardCastle_choice:
			label.text = bad_end
			nextCutscene("end_description")
		else:
			label.text = bad_end
			nextCutscene("end_description")

func start_intro():
	var balloon : Node = Balloon_source.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, "start")

func playWinLose():
	if NpcState.toForest_choice == "accept":
		audio_pool.PlayIndexSound(0)
	else:
		audio_pool.PlayIndexSound(1)
