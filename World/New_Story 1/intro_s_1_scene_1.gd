extends Level

@onready var cut_scene = $CutScene
@onready var villager_1 = $S1IntroVil1
@onready var villager_2 = $S1IntroVil2


func _ready():
	QuestSystem.connectAllNodes()
	addDoorToDoors()
	player.disable()
	player.visible = false
	
	if data == null:
		enter_level()
	nextCutscene("PlayerDialogue")
	
	player.playerFinishedTalking.connect(nextCutscene.bind("PlayerDialogueEnd"))
	villager_1.finished_Chatting.connect(nextCutscene.bind("finishedCutscene"))
	villager_2.finished_Chatting.connect(nextCutscene.bind("finishedCutscene"))

func nextCutscene(next_scene):
	cut_scene.play(next_scene)
