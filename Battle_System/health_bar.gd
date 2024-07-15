extends ProgressBar

@onready var label = $Label

var current_health = 0

func initialize(maximum):
	self.max_value = maximum
	self.value = maximum

func _on_health_change(health):
	animate_healthbar(current_health, health)
	current_health = health
	label.text = "%s / %s" % [health, max_value]

func animate_healthbar(start, end):
	var tween = create_tween()
	tween.tween_property(self, "value", end, 0.6).from_current().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.play()
