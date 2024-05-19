extends CharacterBody2D
class_name NPC


var player
var is_in_chatting_zone = false
var is_chatting = false
var to_next_text = false

@export_file("*.json") var dialogue_text
@onready var chat_bubble = $ChatBubble

var dialogue = []
var dialogue_index = 0

func _ready():
	dialogue = load_dialogue()
	dialogue_index = -1

func start_chatting():
	chat_bubble.visible = true
	next_text()

func _process(delta):
	if Input.is_action_just_pressed("Interact") and !is_chatting and is_in_chatting_zone:
		is_chatting = true
		player.is_chatting = true
		start_chatting()
		print("Is Chatting")

func _on_interaction_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		is_in_chatting_zone = true

func _on_interaction_body_exited(body):
	if body.is_in_group("Player"):
		player = null
		is_in_chatting_zone = false
		chat_bubble.visible = false
		dialogue_index = -1

func _input(event):
	if event.is_action_pressed("Interact") and to_next_text:
		print("pressed")
		to_next_text = false
		next_text()

func load_dialogue():
	var file = FileAccess.open(dialogue_text, FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content

func next_text():
	print(to_next_text)
	dialogue_index += 1
	print(len(dialogue))
	if dialogue_index >= len(dialogue):
		print("finished chatting")
		is_chatting = false
		player.is_chatting = false
		return
		
	chat_bubble.display_text(dialogue[dialogue_index]['name'], dialogue[dialogue_index]['text'])


func _on_chat_bubble_finshed_chatting():
	print("end of text")
	to_next_text = true
