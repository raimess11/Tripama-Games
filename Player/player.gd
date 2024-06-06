extends CharacterBody2D
class_name Player


const SPEED = 500.0
const ACCELERATION = 1500.0
const FRICTION = 2000.0
const AIR_FRICTION = 1200.0
const JUMP_VELOCITY = -400.0

@onready var sprite = $Sprite2D
#@onready var interact_sound = $InteractSound
@onready var player_anim = $PlayerAnim
@onready var audio_queue = $AudioQueue
@onready var walk_sfx = $WalkSfx
@onready var chat_bubble = $ChatBubble

@export_file("*.json") var dialogue_text

var dialogue = []
var dialogue_index = 0


var is_chatting = false
var input_enabled = true
var to_next_text = false

signal playerFinishedTalking

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	player_anim.play("Idle")
	
	#Load initial dialogue
	dialogue = load_dialogue()
	dialogue_index = -1

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if input_enabled:
		if (!is_chatting):
			# Handle Jump.
			if Input.is_action_just_pressed("ui_accept") and is_on_floor():
				velocity.y = JUMP_VELOCITY

			# Get the input direction and handle the movement/deceleration.
			# As good practice, you should replace UI actions with custom gameplay actions.
			var direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
			if direction:
				player_anim.play("Walk")
				if direction == -1:
					player_anim.flip_h = true
				else:
					player_anim.flip_h = false
				velocity.x = move_toward(velocity.x, SPEED * direction, ACCELERATION * delta)
				if !walk_sfx.playing:
						walk_sfx.play()
			else:
				if walk_sfx.playing:
					walk_sfx.stop()
				player_anim.play("Idle")
				if !is_on_floor():
					velocity.x = move_toward(velocity.x, 0, AIR_FRICTION * delta)
				else:
					velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		else:
			player_anim.play("Idle")
			velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	move_and_slide()

func _input(event):
	if event.is_action_pressed("Interact") and is_chatting and !input_enabled:
		if to_next_text:
			next_text()
			to_next_text = false
			playInteractSound()

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

#Parts for dialogue
#Start the chatting bubble
func start_chatting():
	disable()
	chat_bubble.disable = false
	chat_bubble.visible = true
	is_chatting = true
	next_text()

#Load dialogue from JSON file to array
func load_dialogue():
	var file = FileAccess.open(dialogue_text, FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content

#Shift from first text to another by adding the index
func next_text():
	dialogue_index += 1
	#If the out of dialogue complete chatting
	if dialogue_index >= len(dialogue):
		emit_signal("playerFinishedTalking")
		is_chatting = false
		chat_bubble.hide()
		enable()
		return
	
	#Display the new text with chat bubble
	chat_bubble.display_text(dialogue[dialogue_index]['name'], dialogue[dialogue_index]['text'])

func set_next_text(value):
	to_next_text = value

func play_walk():
	print("walking")
	player_anim.play("Walk")
func play_idle():
	player_anim.play("Idle")
