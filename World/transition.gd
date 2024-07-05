extends CanvasLayer
class_name TransitionScreen

signal transition_is_complete

@onready var panel = $Control/Panel
@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer

var starting_animation_name : String

#Called by scene manager to play intro of the transision
func start_transition(animation_name:String):
	if !animation_player.has_animation(animation_name):
		push_warning("'%s' animation does not exist" % animation_name)
		animation_name = "fade_to_black"
	starting_animation_name = animation_name
	animation_player.play(starting_animation_name)

#Called by scene manager to play outro of the transision once content is loaded
func finish_transition():
	print("finish transition")
	var ending_animation_name : String = starting_animation_name.replace("to", "from")
	
	#Check if animation exist if not print warning and set to fade_from_black
	if !animation_player.has_animation(ending_animation_name):
		push_warning("'%s' animation does not exist" % ending_animation_name)
		ending_animation_name = "fade_to_black"
	animation_player.play(ending_animation_name)
	
	#once the final animationplay, free this scene
	await animation_player.animation_finished
	queue_free()

func report_midpoint():
	transition_is_complete.emit()
