@tool
extends Node
class_name AudioPool

var _sounds : Array[AudioQueue]
var _random = RandomNumberGenerator.new()
var _lastIndex: int = -1

func _ready():
	for child in get_children():
		if child is AudioQueue:
			_sounds.append(child)

func PlayRandomSound(ding : bool):
	var index = _random.randi_range(0, _sounds.size()-1)
	while index == _lastIndex:
		index = _random.randi_range(0, _sounds.size()-1)
	if ding:
		index = 3
	_lastIndex = index
	_sounds[index].PlaySound()

func PlayIndexSound(index : int):
	_lastIndex = index
	_sounds[index].PlaySound()
