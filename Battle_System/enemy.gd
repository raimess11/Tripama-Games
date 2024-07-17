extends CharacterBody2D

signal enemy_attack(dmg)
signal enemy_finished_action
signal enemy_dead

@export var starting_stats : StartingStats

@onready var stats = $Stats
@onready var health_bar = $HealthBar
@onready var enemy_anim = $EnemyAnim
@onready var animation_player = $AnimationPlayer
@onready var vfx = $VFX

func _ready():
	stats.initialize(starting_stats)
	health_bar.initialize(stats.max_health)

func action():
	emit_signal("enemy_attack", stats.strength)
	enemy_anim.play("Attack")
	vfx.play("Attack")
	AudioManager.playIndexSwordHit(0)
	await enemy_anim.animation_finished
	enemy_anim.play("Idle")
	emit_signal("enemy_finished_action")

func hit(dmg):
	animation_player.play("hurt")
	vfx.play("Hit")
	AudioManager.playOompaLoompaVoice()
	stats.take_damage(dmg)
	if stats.health == 0:
		
		animation_player.play("death")
		await animation_player.animation_finished
