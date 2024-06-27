extends CharacterBody2D
class_name NPC

signal chat_ends
signal interacted

var is_chatting = false

@onready var action = $Action
@onready var actionable = $Actionable

func _ready():
	actionable.connect("dialogueEnds", _on_Dialogue_ends)

func _on_Dialogue_ends():
	emit_signal("chat_ends")

func start_dialogue():
	emit_signal("interacted")
	actionable.action()
