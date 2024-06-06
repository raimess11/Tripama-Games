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
signal letNPC_talk

func _ready():
	#Load initial dialogue
	dialogue = load_dialogue()
	dialogue_index = -1

#Start the chatting bubble
func start_chatting():
	chat_bubble.disable = false
	chat_bubble.visible = true
	is_chatting = true
	if has_interacted:
		interacted_chat()
		player.is_chatting = false
	else:
		emit_signal("interacted")
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
	if event.is_action_pressed("Interact") and to_next_text and player != null:
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
		print("finished Chat")
		if not has_interacted:
			has_interacted = true
		is_chatting = false
		player.is_chatting = false
		chat_bubble.hide()
		emit_signal("finished_Chatting")
		return
	
	#Let other NPC talk when given *change NPC*
	if dialogue[dialogue_index]['text'] == "*change NPC*":
		emit_signal("letNPC_talk")
		chat_bubble.hide()
		chat_bubble.disable = true
		return
	
	#Display the new text with chat bubble
	chat_bubble.text_finished = false
	chat_bubble.display_text(dialogue[dialogue_index]['name'], dialogue[dialogue_index]['text'])

func handle_others_chat():
	if !is_chatting:
		for child in get_parent().get_children():
			if child.is_in_group("Player"):
				player = child
				break
		start_chatting()
	else:
		chat_bubble.show()
		chat_bubble.disable = false
		next_text()

func finished_cutscene():
	player = null
	is_chatting = false
	has_interacted = true
	chat_bubble.hide()

func set_next_text(value):
	to_next_text = value

func interacted_chat():
	var index = len(dialogue)-1
	chat_bubble.display_text(dialogue[index]['name'],"Interact with villager")
	is_chatting = false
	emit_signal("finished_Chatting")
