extends BattleLevel

signal end_scene

var character_selection = "res://GUI/character_select_screen.tscn"
@onready var cut_scene = $CutScene


func battle_complete():
	ui.hide()
	cut_scene.play("start_end")
	print("start anim")
	ui.hide()
	await cut_scene.animation_finished
	print("wait input")
	ui.hide()
	await end_scene
	print("anim end")
	cut_scene.play("end_end")
	await cut_scene.animation_finished
	SceneManager.load_new_scene(character_selection,"fade_to_black")

func _input(event):
	if event.is_action_pressed("ui_accept") and text_box.visible:
		text_box.hide()
		emit_signal("textbox_closed")
	
	if event.is_action_pressed("ui_accept") and !text_box.visible:
		emit_signal("end_scene")
