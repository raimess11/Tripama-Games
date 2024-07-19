extends Button

@export_file var level_path

func _on_pressed():
	SfxButton.play()
	if level_path == null:
		return
	$".".disabled = true
	Loading.startLoad()
	await Loading.loading_finished
	SceneManager.load_new_scene(level_path, "fade_to_black")
	$".".disabled = true
