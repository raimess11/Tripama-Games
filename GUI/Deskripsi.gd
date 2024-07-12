extends Button

@export_file var path

func _on_pressed():
	SfxButton.play()
	if path == null:
		return
	get_tree().change_scene_to_file(path)
