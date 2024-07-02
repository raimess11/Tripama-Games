@tool
extends Node
class_name AudioQueue


@export var count : int = 1

var _next = 0
var _audioStreamPlayer : Array[AudioStreamPlayer] =  []

func _ready():
	if self.get_child_count() == 0:
		print("No AudioStreamPlayer child found")
		return
	
	var child = self.get_child(0)
	if child is AudioStreamPlayer:
		_audioStreamPlayer.append(child)
		child.bus = "SFX"
		for i in count:
			var duplicate = child.duplicate()
			self.add_child(duplicate) 
			_audioStreamPlayer.append(duplicate)

func _get_configuration_warnings():
	if (self.get_child_count() == 0):
		return "No children found. Expected one AudioStreamPlayer child"
	
	if not (self.get_child(0) is AudioStreamPlayer):
		return "Expeted first child to be an AudioStreamPlayer"

func PlaySound():
	if not _audioStreamPlayer[_next].playing:
		_audioStreamPlayer[_next+1].play()
		_next %= _audioStreamPlayer.size()
