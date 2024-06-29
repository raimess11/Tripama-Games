extends Node
"""
State of which has the player interacted with the NPC or not
Used for dialogues
"""


#Story 1 Suwanda Arc
#Quest dictionary
var questNPC = [{"questS1Scene1": false, #Scene 1
				"questS1Scene2": false, #Scene 2
				"questS1Scene4": false #Scene 4
				}]

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
