extends BattleLevel

signal battle_finished

func battle_complete():
	emit_signal("battle_finished")
