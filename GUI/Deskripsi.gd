extends Button

@export_file var path

func _on_pressed():
	SfxButton.play()
	if path == null:
		return
	TextTransition.changeMenu(path)
