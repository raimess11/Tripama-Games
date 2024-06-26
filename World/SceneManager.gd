"""
Scene manager is used to manage all scene transition
"""

extends Node


var LEVEL_W:int = 1920
var LEVEL_H:int = 1080

signal content_finished_loading(content)
signal zelda_content_finished_loading(content)
signal content_invalid(content_path : String)
signal content_failed_to_load(content_path : String)

var _transition : String
var _content_path : String
var _load_progress_timer:Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("content_invalid", on_content_invalid)
	self.connect("content_failed_to_load", on_content_failed_to_load)
	self.connect("content_finished_loading", on_content_finished_loading)
	self.connect("zelda_content_finished_loading", on_zelda_content_finished_loading)

#Set the transition to zelda style
func load_level_zelda(content_path : String) -> void:
	_transition = "zelda"
	_load_content(content_path)

#Load all content before actual transition
func _load_content(content_path : String):
	_content_path = content_path
	var loader = ResourceLoader.load_threaded_request(content_path)
	if not ResourceLoader.exists(content_path) or loader == null:
		content_invalid.emit(content_path)
		return
	
	#Wait for the content to fully with loading screen
	_load_progress_timer = Timer.new()
	_load_progress_timer.wait_time = 0.1
	_load_progress_timer.timeout.connect(monitor_load_status)
	get_tree().root.add_child(_load_progress_timer)
	_load_progress_timer.start()

#Monitor content loading for loading screen
func monitor_load_status() -> void:
	var load_progress = []
	var load_status = ResourceLoader.load_threaded_get_status(_content_path, load_progress)
	
	#Handle loading update, finished, and error
	match load_status:
		#When content invalid
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			content_invalid.emit(_content_path)
			_load_progress_timer.stop()
			return
		#Update load
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			#Add loading update here
			pass
		#Failed to load file
		ResourceLoader.THREAD_LOAD_FAILED:
			content_failed_to_load.emit(_content_path)
			_load_progress_timer.stop()
			return
		#Finished Loading content
		ResourceLoader.THREAD_LOAD_LOADED:
			_load_progress_timer.stop()
			_load_progress_timer.queue_free()
			if _transition == "zelda":
				zelda_content_finished_loading.emit(ResourceLoader.load_threaded_get(_content_path).instantiate())
			else:
				content_finished_loading.emit(ResourceLoader.load_threaded_get(_content_path).instantiate())
			return

#Error print
func on_content_invalid(path : String):
	printerr("error: Cannot load resource: '%s'" % [path])

func on_content_failed_to_load(path : String):
	printerr("error: Failed to load resource: '%s'" % [path])	
###

func on_content_finished_loading():
	pass

#Zelda style transition
func on_zelda_content_finished_loading(content):
	var outgoing_scene = get_tree().current_scene
	
	#Get data from previous scene
	var incoming_data : LevelDataHandoff
	if  get_tree().current_scene is Level:
		incoming_data = get_tree().current_scene.data as LevelDataHandoff
	
	if content is Level:
		content.data = incoming_data
	
	# slide new level in
	content.position.x = incoming_data.move_dir.x * LEVEL_W
	content.position.y = incoming_data.move_dir.y * LEVEL_H
	var tween_in:Tween = get_tree().create_tween()
	tween_in.tween_property(content, "position", Vector2.ZERO, 1).set_trans(Tween.TRANS_SINE)
	
	# slide old level out
	var tween_out:Tween = get_tree().create_tween()
	var vector_off_screen:Vector2 = Vector2.ZERO
	vector_off_screen.x = -incoming_data.move_dir.x * LEVEL_W
	vector_off_screen.y = -incoming_data.move_dir.y * LEVEL_H
	tween_out.tween_property(outgoing_scene, "position", vector_off_screen, 1).set_trans(Tween.TRANS_SINE)
	
	# add new scene to the tree - (Note: could be loaded into a container instead)
	get_tree().root.call_deferred("add_child",content)
	
	# once the tweens are done, do some cleanup
	await tween_in.finished
	
	# skipped if not a Level
	if content is Level:
		content.init_player_location()
		content.enter_level()
	
	# Remove the old scene
	outgoing_scene.queue_free()
	# Add and set the new scene to current - so we can get its data obj next time we move between Levels
	get_tree().current_scene = content
