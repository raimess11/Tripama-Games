extends CharacterBody2D

signal player_attack(dmg)
signal player_defend()
signal player_finished_action
signal player_dead

@export var starting_stats : StartingStats

@onready var stats = $Stats
@onready var health_bar = $HealthBar
@onready var player_anim = $PlayerAnim
@onready var animation_player = $AnimationPlayer

var defended = false

# Called when the node enters the scene tree for the first time.
func _ready():
	stats.initialize(starting_stats)
	health_bar.initialize(stats.max_health)

func attack():
	emit_signal("player_attack", stats.strength)
	player_anim.play("Attack")
	AudioManager.playIndexSwordHit(1)
	await player_anim.animation_finished
	player_anim.play("Idle")

func defend():
	emit_signal("player_defend")
	animation_player.play("defend")
	AudioManager.playIndexUnsheate(1)
	defended = true
	stats.defend()

func hit(dmg):
	animation_player.play("hurt")
	if defended:
		AudioManager.playIndexParry(0)
	else:
		AudioManager.playIndexMaleVoice(1)
	defended = false
	stats.take_damage(dmg)
	if stats.health == 0:
		animation_player.play("death")
		await animation_player.animation_finished
		emit_signal("player_dead")
