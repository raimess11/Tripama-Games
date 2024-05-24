extends CharacterBody2D
class_name Player


const SPEED = 500.0
const ACCELERATION = 1500.0
const FRICTION = 2000.0
const AIR_FRICTION = 1200.0
const JUMP_VELOCITY = -400.0

@onready var sprite = $Sprite2D
@onready var interact_sound = $InteractSound
@onready var player_anim = $PlayerAnim


var is_chatting = false
var input_enabled = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	player_anim.play("Idle")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if (!is_chatting) and input_enabled:
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
		else:
			player_anim.play("Idle")
			if !is_on_floor():
				velocity.x = move_toward(velocity.x, 0, AIR_FRICTION * delta)
			else:
				velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		
	else:
		player_anim.play("Idle")
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	move_and_slide()
	

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
	interact_sound.play()
