extends Level

@onready var cut_scene = $CutScene
const Balloon_source = preload("res://NPC/DialogueSystem/Bubble/balloon.tscn")
var character_selection = "res://GUI/character_select_screen.tscn"
@export var dialogue_resource : DialogueResource
@onready var audio_pool = $AudioPool
@onready var label = $Overlay/Label
@onready var texture_rect = $Overlay/TextureRect

func _ready():
	cut_scene.play("RESET")
	QuestSystem.connectAllNodes()
	NpcState.has_interacted.connect(_update_doors)
	addDoorToDoors()
	connect_NPC_to_player()
	player.disable()
	player.visible = false
	
	if data == null:
		enter_level()
	nextCutscene("start_monologue")
	
	player.is_chatting = true
	DialogueManager.dialogue_ended.connect(_on_Dialogue_Ended)
	
	if NpcState.choice_scene2 == "c2":
		texture_rect.self_modulate = Color("#74a24e")
		label.text = "Good End"
		label.modulate = Color.GREEN
	else:
		texture_rect.self_modulate = Color("#a86d46")
		label.text = "Bad End"
		label.modulate = Color.RED

func nextCutscene(next_scene):
	cut_scene.play(next_scene)

func _on_Dialogue_Ended(source):
	if source == dialogue_resource:
		nextCutscene("end")

func start_intro():
	var balloon : Node = Balloon_source.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, "start")

func play_sfx():
	if NpcState.choice_scene2 == "c2":
		AudioManager.playWin()
	else:
		AudioManager.playLose()


func _on_cut_scene_animation_finished(anim_name):
	if anim_name == "end":
		await get_tree().create_timer(5).timeout
		NpcState.reset()
		SceneManager.load_new_scene(character_selection,"fade_to_black")
	
