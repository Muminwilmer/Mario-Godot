extends CharacterBody2D

# Physics constants
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Movement settings
@export var max_walk_speed = 150.0
@export var max_run_speed = 300.0
@export var max_fall_speed = 240.0
@export var accel = 14.0
@export var friction = 0.2
@export var running_multiplier = 2.5

# Jump settings
@export var jump_force = 350.0
@export var small_jump_force = 100.0
@export var min_jump_time = 0.3

# State variables
var is_running = false
var is_jumping = false
var jump_hold_time = 0.0
var current_speed = Vector2(0,0)
var respawn_position = Vector2(0,0)

@export var last_frame_pos = Vector2(0,0)
@export var animation_speed = 8


# Initialization
func _ready():
	respawn_position = position

# Reset character position
func reset_character():
	position = respawn_position

# Main physics logic
func _physics_process(delta):
	handle_gravity(delta)
	handle_movement(delta)
	handle_jump(delta)
	handle_actions()
	move_and_slide()

# Gravity logic
func handle_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = clamp(velocity.y, -INF, max_fall_speed)
	if position.y > 700:
		handle_death()

# Movement logic
func handle_movement(_delta):
	is_running = Input.is_action_pressed("Run")
	var max_speed = max_walk_speed if not is_running else max_run_speed
	
	# Horizontal movement
	if Input.is_action_pressed("Right"):
		current_speed.x += accel * (2 if is_running else 1)
		current_speed.x = clamp(current_speed.x, -max_speed, max_speed)
		if is_on_floor():
			play_run_animation(false)
	elif Input.is_action_pressed("Left"):
		current_speed.x -= accel * (2 if is_running else 1)
		current_speed.x = clamp(current_speed.x, -max_speed, max_speed)
		if is_on_floor():
			play_run_animation(true)
	else:
		current_speed.x = lerp(current_speed.x, 0.0, friction)
		if is_on_floor():
			$AnimationPlayer.stop()
	
	velocity.x = current_speed.x
	if (last_frame_pos == round(position * 10) / 10.0):
		$Sprite2D.frame = 0
	last_frame_pos = round(position * 10) / 10.0
	

# Jump logic
func handle_jump(delta):
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		is_jumping = true
		jump_hold_time = 0.0
		velocity.y = -jump_force
		$Sprite2D.frame = 5
		$JumpAudio.play(0.14)

	if is_jumping:
		jump_hold_time += delta
		if not Input.is_action_pressed("Jump") and jump_hold_time < min_jump_time:
			velocity.y = -small_jump_force
			is_jumping = false

# Handle additional actions
func handle_actions():
	if Input.is_action_pressed("Duck"):
		$Sprite2D.frame = 6
	if Input.is_action_pressed("Reset"):
		reset_character()

# Play run animation
func play_run_animation(flip_h: bool):
	$Sprite2D.flip_h = flip_h
	if is_running:
		animation_speed = 16
	$AnimationPlayer.speed_scale = animation_speed
	if (last_frame_pos != round(position * 10) / 10.0):
		$AnimationPlayer.play("Run")
	else:
		$AnimationPlayer.stop()

func handle_death():
	Global.PlayerLives -= 1
	if (Global.PlayerLives>0):
		print("You died.")
		print("You now only have "+str(Global.PlayerLives)+" lives left!")
		reset_character()
	else:
		print("Game Over.")
		#Crash the game on game over :P
		print(Global.nonexistantvar)
