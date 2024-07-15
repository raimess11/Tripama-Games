extends Control

func _ready():
	$AnimationPlayer.play("RESET")

func resume():
	$AnimationPlayer.play_backwards("Blur")
	await $AnimationPlayer.animation_finished
	get_tree().paused = false
	

func pause():
	$AnimationPlayer.play("Blur")
	await $AnimationPlayer.animation_finished
	get_tree().paused = true

func restart():
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func menu():
	get_tree().change_scene_to_file("res://GUI/character_select_screen.tscn")
	get_tree().paused = false
	

func handler():
	if Input.is_action_just_pressed("Pause") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("Pause") and get_tree().paused:
		resume()


func _on_resume_pressed():
	SfxButton.play()
	resume()


func _on_restart_pressed():
	SfxButton.play()
	restart()


func _on_menu_pressed():
	SfxButton.play()
	menu()

func _process(delta):
	handler()
