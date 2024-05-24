extends CharacterBody2D
class_name NPC


var player
var is_in_chatting_zone = false
var is_chatting = false
var to_next_text = false
var has_interacted = false

@export_file("*.json") var dialogue_text
@onready var chat_bubble = $ChatBubble
@onready var action = $Action

var dialogue = []
var dialogue_index = 0

signal finished_Chatting
signal interacted

func _ready():
	#Load initial dialogue
	dialogue = load_dialogue()
	dialogue_index = -1

#Start the chatting bubble
func start_chatting():
	chat_bubble.visible = true
	next_text()

func _process(delta):
	if Input.is_action_just_pressed("Interact") and !is_chatting and is_in_chatting_zone:
		is_chatting = true
		player.is_chatting = true
		player.playInteractSound()
		start_chatting()

#Check if player in area
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
		to_next_text = false
		player.playInteractSound()
		next_text()

#Load dialogue from JSON file to array
func load_dialogue():
	var file = FileAccess.open(dialogue_text, FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content

#Shift from first text to another by adding the index
func next_text():
	dialogue_index += 1
	#If the out of dialogue complete chatting
	if dialogue_index >= len(dialogue):
		emit_signal("finished_Chatting")
		if not has_interacted:
			has_interacted = true
			emit_signal("interacted")
		is_chatting = false
		player.is_chatting = false
		return
	
	#Display the new text with chat bubble
	chat_bubble.display_text(dialogue[dialogue_index]['name'], dialogue[dialogue_index]['text'])

func _on_chat_bubble_finshed_chatting():
	to_next_text = true
