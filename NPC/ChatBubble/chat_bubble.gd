extends MarginContainer


@onready var timer = $Timer
@onready var label = $MarginContainer/VBoxContainer/Text
@onready var nameLabel = $MarginContainer/VBoxContainer/Name

const MAX_WIDTH = 300

var text = ""
var letter_index = 0

var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.2

signal finshed_chatting()

var text_finished = false

func display_text(job: String ,text_display: String):
	text_finished = false
	text = text_display
	label.text = text_display
	nameLabel.text = job
	
	#await resized
	##await resized
	await get_tree().create_timer(0.01).timeout
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y
	
	label.text = ""
	letter_index = 0
	display_letter()

func _input(event):
	if event.is_action_pressed("Interact") and !text_finished:
		text_finished = true
		letter_index = text.length()-2
		label.text = text

func display_letter():
	label.text += text[letter_index]
	
	letter_index += 1
	
	if letter_index >= text.length():
		text_finished = true
		finshed_chatting.emit()
		return
	
	match text[letter_index]:
		"!", "?", ".", ",":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)
	
	


func _on_timer_timeout():
	display_letter()
