extends Node
"""
State of which has the player interacted with the NPC or not
Used for dialogues
"""

signal has_interacted(leftDoor, state)

func emit_has_interacted(leftDoor, state):
	emit_signal("has_interacted", leftDoor, state)

#Quest dictionary
var questNPC = [{"questS1Scene1": false, #Scene 1
				"questS1Scene2": false, #Scene 2
				"questS1Scene4": false #Scene 4
				},
				{"questS2Scene2": false #Scene 2
				},
				{"questS3Scene1": false #Scene 1
				}]

#Story 1 Suwanda Arc
#Scene 1
var villager1and2_Scene1 = false
var questVillager_Scene1 = false

#Scene 2
var guard_scene2 = false
var questGuard_Scene2 = false

#Scene 4
var king_scene4 = false
var questKing_Scene4 = false

#Scene 5
var kuliah_scene5 = false

#Scene 3
var dayang_scene3 = false
var guard_scene3 = false

#Scene 4 v2
var king_scene4_war = false

#Scene 1 v2
var vil12_scene1_war = false
var accept_help_S1 = false

#Story 2 Kumbakarna Arc
#Scene 1
var forest_scene1 = false
var forest2_scene1 = false

#Scene 2
var desa_scene2 = false
var choice_scene2 = "c2" # Possible choice c1, c2, c3

#Scene 3
var penasihat_scene3 = false

#Scene 4
var war_scene4 = false

#Scene 5
var monologue_kumbakarna = false

#Story 3 Karna Arc
#Scene 1
var toForest_scene1 = false
var toForest_choice = "accept" # Possible choice accept, refuse, ...

#Scene 2
var forest_scene2 = false
var monologue_scene2 = false

#Scene 3
var guardCastle_scene3 = false
var guardCastle_choice = false
