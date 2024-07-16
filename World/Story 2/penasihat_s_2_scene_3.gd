extends Level

@onready var cut_scene = $CutScene


func _ready():
	QuestSystem.connectAllNodes()
	NpcState.has_interacted.connect(_update_doors)
	addDoorToDoors()
	connect_NPC_to_player()
	player.disable() #ini gk kepanggil njir wkwkwk
	player.visible = false
	
	if data == null:
		enter_level()
	
	DialogueManager.dialogue_ended.connect(_on_Dialogue_Ended)
	player.disable()
	cut_scene.play("fade_out")
	await cut_scene.animation_finished
	$Overlay.visible = false
	TextTransition.transisition("s2desc1")
	await TextTransition.TextTransitionEnd
	player.enable()

func nextCutscene(next_scene):
	cut_scene.play(next_scene)

func _on_Dialogue_Ended(source):
	print("end_scene")
	$Overlay.visible = true
	nextCutscene("end_scene")
