extends Resource
class_name TurnManager

enum {ALLY_TURN, ENEMY_TURN}

var turn: int:
	get: return turn
	set(value):
		turn = value
		match turn:
			ALLY_TURN: emit_signal("ally_turn_started")
			ENEMY_TURN: emit_signal("enemy_turn_started")

signal ally_turn_started
signal enemy_turn_started
