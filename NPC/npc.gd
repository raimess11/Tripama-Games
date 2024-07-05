extends CharacterBody2D
class_name NPC

signal chat_ends
signal interacted

var is_chatting = false

@onready var action = $Action
@onready var actionable = $Actionable
@onready var label = $Label

func _ready():
	actionable.connect("dialogueEnds", _on_Dialogue_ends)
	actionable.connect("dialogueStart", _on_Dialogue_start)

func _on_Dialogue_ends():
	emit_signal("interacted")
	label.show()
	await get_tree().create_timer(1.0).timeout
	emit_signal("chat_ends")

func _on_Dialogue_start():
	label.hide()

func start_dialogue():
	emit_signal("interacted")
	actionable.action()

func _on_actionable_area_entered(area):
	label.show()
	
func _on_actionable_area_exited(area):
	label.hide()
