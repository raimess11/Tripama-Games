extends CanvasLayer

signal loading_finished

@onready var colorRect = $ColorRect
@onready var loadBar = $ColorRect/VBoxContainer/LoadingBar
@onready var time = $ColorRect/VBoxContainer/LoadingBar/Timer

var timePercent

func _ready():
	colorRect.visible = false


func startLoad():
	colorRect.visible = true
	time.start()
	

func get_scene(percentage):
	if percentage == 100:
		loading_finished.emit()
		colorRect.visible = false
	else:
		return

func _process(delta):
	timePercent = (time.wait_time - time.time_left) / time.wait_time * 100
	loadBar.value = timePercent
	get_scene(timePercent)
