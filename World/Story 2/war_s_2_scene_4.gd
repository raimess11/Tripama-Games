extends Level

@onready var cut_scene = $CutScene
const Balloon_source = preload("res://NPC/DialogueSystem/Bubble/balloon.tscn")
@export var dialogue_resource : DialogueResource
@onready var overlay = $Overlay

var _transition_scene : PackedScene = preload("res://World/transition.tscn")
var battle_path : PackedScene = preload("res://Battle_System/Story 2/s_2_battle.tscn")

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
		await get_tree().create_timer(5).timeout
		nextCutscene("end")
	if anim_name == "temp_battle":
		nextCutscene("arrow_cutscene")

func start_battle():
	var inCamera : Camera2D
	var transition_screen: TransitionScreen
	#Start transition
	transition_screen = _transition_scene.instantiate() as TransitionScreen
	get_tree().root.add_child(transition_screen)
	transition_screen.start_transition("fade_to_black")
	if transition_screen != null:
		await transition_screen.transition_is_complete
	
	#Instantiate battle level
	var battle_scene = battle_path.instantiate() as BattleLevel
	#Get camera
	for child in battle_scene.get_children():
		if child is Camera2D:
			inCamera = child
	
	camera.enabled = false
	inCamera.enabled = false
	get_tree().root.add_child(battle_scene)
	battle_scene.battle_finished.connect(end_battle.bind(battle_scene))
	cut_scene.pause()
	overlay.hide()
	self.hide()
	inCamera.enabled = true
	transition_screen.finish_transition()
	

func end_battle(scene):
	var transition_screen: TransitionScreen
	var inCamera : Camera2D
	#Start transition
	transition_screen = _transition_scene.instantiate() as TransitionScreen
	get_tree().root.add_child(transition_screen)
	transition_screen.start_transition("fade_to_black")
	if transition_screen != null:
		await transition_screen.transition_is_complete
	#Get camera
	for child in scene.get_children():
		if child is Camera2D:
			inCamera = child
	
	camera.enabled = false
	inCamera.enabled = false
	self.show()
	overlay.show()
	scene.queue_free()
	camera.enabled = true
	transition_screen.finish_transition()
	cut_scene.play("temp_battle")
