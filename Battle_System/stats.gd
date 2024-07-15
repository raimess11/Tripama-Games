extends Node
class_name CharacterStats

signal health_change(value)
signal health_depleted

var job_name: String
var health: int
var max_health: int
var strength: int
var defence: int
var armor: int

func initialize(stats: StartingStats):
	job_name= stats.job_name
	max_health = stats.max_health
	strength = stats.strength
	defence = stats.defence
	health = max_health
	armor = stats.armor
	emit_signal("health_change", health)

func set_max_health(value):
	max_health = max(0, value)

func take_damage(dmg):
	health -= max(dmg-defence, 0)
	defence = 0
	health = max(0, health)
	emit_signal("health_change", health)
	if health <= 0:
		emit_signal("health_depleted")

func defend():
	defence = armor
