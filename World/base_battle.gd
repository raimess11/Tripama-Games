extends Node2D
class_name BattleLevel

var turn_manager = preload("res://Battle_System/turn_manager.tres")

signal textbox_closed

@export var player_name : String = "Player"

@onready var player = $BattlePlayer
@onready var enemy = $Enemy
@onready var ui = $"Battle Button"
@onready var text_box = $TextBox
@onready var label = $TextBox/Control/MarginContainer/Label


# Called when the node enters the scene tree for the first time.
func _ready():
	text_box.hide()
	turn_manager.ally_turn_started.connect(_on_ally_turn_started)
	turn_manager.enemy_turn_started.connect(_on_enemy_turn_started)
	player.player_dead.connect(_on_player_died)
	enemy.enemy_dead.connect(_on_enemy_died)

func _input(event):
	if event.is_action_pressed("ui_accept") and text_box.visible:
		text_box.hide()
		emit_signal("textbox_closed")

func _on_ally_turn_started():
	print("Ui show")
	if not is_instance_valid(player) or player.stats.health == 0: return
	if not is_instance_valid(enemy): return
	ui.show()

func _on_enemy_turn_started():
	if not is_instance_valid(player) or player.stats.health == 0: return
	ui.hide()
	
	if enemy.stats.health == 0:
		_on_enemy_died()
		return
	
	enemy.action()
	show_textbox("Musuh menyerang %s dengan %d damage" % [player.stats.job_name, enemy.stats.strength])
	await textbox_closed
	turn_manager.turn = TurnManager.ALLY_TURN

func show_textbox(text):
	ui.hide()
	text_box.show()
	label.text = text

func _on_attack_pressed():
	player.attack()
	show_textbox("%s menyerang musuh dengan %d damage" % [player.stats.job_name, player.stats.strength])
	await textbox_closed
	turn_manager.turn = TurnManager.ENEMY_TURN

func _on_defend_pressed():
	player.defend()
	show_textbox("%s bertahan" % [player.stats.job_name])
	await textbox_closed
	turn_manager.turn = TurnManager.ENEMY_TURN

func _on_player_died():
	show_textbox("%s kalah" % [player.stats.job_name])
	AudioManager.playLose()
	await textbox_closed
	battle_complete()

func _on_enemy_died():
	show_textbox("musuh berhasil dikalahkan")
	AudioManager.playWin()
	await textbox_closed
	battle_complete()

func battle_complete():
	queue_free()
