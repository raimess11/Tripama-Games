extends Button

@export_file var level_path

func _on_pressed():
	if level_path == null:
		return
	$".".disabled = true
	SfxButton.play()
	Loading.startLoad()
	await Loading.loading_finished
	SceneManager.load_new_scene(level_path, "fade_to_black")
	$".".disabled = true
