extends Node

func find(reference : Quest):
	for quest in self.get_children():
		if quest.name == reference.name:
			return quest

func getQuest() -> Array:
	return self.get_children()
