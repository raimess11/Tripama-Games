extends Area2D

signal dialogueEnds

@export var dialogue_resource : DialogueResource
@export var dialogue_start : String = "start"

func _ready():
	DialogueManager.dialogue_ended.connect(_on_Dialogue_Ended)

func action():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)

func _on_Dialogue_Ended(resource):
	if resource == dialogue_resource:
		emit_signal("dialogueEnds")
