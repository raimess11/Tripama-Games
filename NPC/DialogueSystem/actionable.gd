extends Area2D

signal dialogueEnds

@export var dialogue_resource : DialogueResource
@export var dialogue_start : String = "start"

const Balloon_source = preload("res://NPC/DialogueSystem/Bubble/balloon.tscn")



func _ready():
	DialogueManager.dialogue_ended.connect(_on_Dialogue_Ended)

func action():
	var balloon : Node = Balloon_source.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, dialogue_start)
	#DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)

func _on_Dialogue_Ended(resource):
	if resource == dialogue_resource:
		emit_signal("dialogueEnds")
