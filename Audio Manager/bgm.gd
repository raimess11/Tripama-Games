extends AudioStreamPlayer


func fade_in_bgm(transition_time:float = 1.0):
	var tween = create_tween()
	tween.tween_property(self, "volume_db", -80, transition_time)
	tween.play()

func fade_out_bgm(transition_time:float = 1.0):
	var tween = create_tween()
	tween.tween_property(self, "volume_db", 0, transition_time)
	tween.play()
