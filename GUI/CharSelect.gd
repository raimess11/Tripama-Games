extends Button

@export_file var level_path

func _on_pressed():
	SfxButton.play()
	Loading.startLoad()
	await Loading.loading_finished
	if level_path == null:
		return
	SceneManager.load_new_scene(level_path, "fade_to_black")
