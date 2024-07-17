extends BattleLevel

signal end_scene

var character_selection = "res://GUI/character_select_screen.tscn"
@onready var cut_scene = $CutScene
@onready var label2 = $Overlay/Label


func battle_complete():
	set_text_description()
	ui.hide()
	cut_scene.play("start_end")
	await cut_scene.animation_finished
	await end_scene
	cut_scene.play("end_end")
	await cut_scene.animation_finished
	SceneManager.load_new_scene(character_selection,"fade_to_black")

func _input(event):
	if event.is_action_pressed("ui_accept") and text_box.visible:
		text_box.hide()
		emit_signal("textbox_closed")
	
	if event.is_action_pressed("ui_accept") and !text_box.visible:
		emit_signal("end_scene")

func set_text_description():
	if NpcState.questNPC[0]["questS1Scene5"] and !NpcState.accept_help_S1:
		label2.text = "Guilt End \nPasukan Maespati bertempur sengit dengan raksasa-raksasa dari Alengka.\nSaat Patih Suwanda siap memenggal Prabu Dasamuka, ia melihat adiknya dari mata Dasamuka.\nTeringat oleh dosanya, Patih Suwanda mati ditangan Prabu Dasamuka."
	elif !NpcState.questNPC[0]["questS1Scene5"] and !NpcState.accept_help_S1:
		label2.text = "Guilt End \nPasukan Maespati bertempur sengit dengan raksasa-raksasa dari Alengka.\nIa berjanji akan melindungi Negeri Maespati dari raksasa-rakasasa Alengka.\nSayangnya, ia tak bisa melindungi tanahnya, dan mati dengan kata terakhirnya, \"maaf... maaf...\""
		
