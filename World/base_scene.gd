extends Node2D
class_name Level

@export var player : Player
@export var doors : Array[Door]
var data : LevelDataHandoff

# Called when the node enters the scene tree for the first time.
func _ready():
	addDoorToDoors()
	player.disable()
	player.visible = false
	
	if data == null:
		enter_level()

func enter_level():
	if data != null:
		init_player_location()
	player.enable()
	_connect_to_doors()

func init_player_location():
	if data != null:
		for door in doors:
			if door.name == data.entry_door_name:
				player.position = door.get_player_entry_vector()
		player.orient(data.move_dir)

# signal emitted by Door
# disables doors and players
# create handoff data to pass to the new scene (if new scene is a Level)
func _on_player_entered_door(door:Door) -> void:
	_disconnect_from_doors()
	player.disable()
	player.queue_free()
	data = LevelDataHandoff.new()
	data.entry_door_name = door.entry_door_name
	data.move_dir = door.get_move_dir()

func _connect_to_doors() -> void:
	for door in doors:
		print(doors)
		if not door.player_entered_door.is_connected(_on_player_entered_door):
			door.player_entered_door.connect(_on_player_entered_door.bind(door))

func _disconnect_from_doors() -> void:
	for door in doors:
		if door.player_entered_door.is_connected(_on_player_entered_door):
			door.player_entered_door.disconnect(_on_player_entered_door)

func addDoorToDoors():
	for node in self.get_children():
		if node is Door:
			doors.append(node)
