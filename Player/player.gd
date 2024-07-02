extends CharacterBody2D
class_name Player


const SPEED = 500.0
const ACCELERATION = 1500.0
const FRICTION = 2000.0
const AIR_FRICTION = 1200.0
const JUMP_VELOCITY = -400.0

#@onready var interact_sound = $InteractSound
@onready var player_anim = $PlayerAnim
@onready var audio_queue = $AudioQueue
@onready var walk_sfx = $AudioPool
@onready var action_detector = $ActionDetector

var direction

var footstep_frame : Array = [3, 6]

var is_chatting = false
@export var input_enabled = true
var to_next_text = false

signal playerFinishedTalking

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	player_anim.play("Idle")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if input_enabled:
		if (!is_chatting):
			# Get the input direction and handle the movement/deceleration.
			if direction:
				player_anim.play("Walk")
				if direction == -1:
					player_anim.flip_h = true
					action_detector.scale = Vector2(-1,1)
				else:
					player_anim.flip_h = false
					action_detector.scale = Vector2(1,1)
				velocity.x = move_toward(velocity.x, SPEED * direction, ACCELERATION * delta)
				#if !walk_sfx.playing:
				#		walk_sfx.play()
			else:
				#if walk_sfx.playing:
				#	walk_sfx.stop()
				player_anim.play("Idle")
				if !is_on_floor():
					velocity.x = move_toward(velocity.x, 0, AIR_FRICTION * delta)
				else:
					velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		else:
			player_anim.play("Idle")
			velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	move_and_slide()

func _unhandled_input(event):
	if event.is_action_pressed("Interact"):
		audio_queue.PlaySound()
		var actionables = action_detector.get_overlapping_areas()
		print("Interact", actionables.size())
		if actionables.size() > 0:
			actionables[0].action()
			return
	
	direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

func orient(dir : Vector2):
	if dir.x:
		player_anim.flip_h = dir.x < 0

#Disable input
func disable():
	input_enabled = false
	
func enable():
	input_enabled = true
	visible = true

func playInteractSound():
	audio_queue.PlaySound()

func play_walk():
	print("walking")
	player_anim.play("Walk")
func play_idle():
	player_anim.play("Idle")

func _on_player_anim_frame_changed():
	if player_anim.animation == "Idle": return
	if player_anim.frame in footstep_frame: walk_sfx.PlayRandomSound(false)
