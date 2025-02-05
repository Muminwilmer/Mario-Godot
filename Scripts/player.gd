extends CharacterBody2D

# Physics constants
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Movement settings
@export var max_walk_speed = 150.0
@export var max_run_speed = 220.0
@export var max_fall_speed = 240.0
@export var accel = 15.0
@export var friction = 0.2
@export var running_multiplier = 2.0

# Jump settings
@export var jump_force = 350.0
@export var default_jump_force = 100.0
@export var small_jump_force = default_jump_force
@export var min_jump_time = 0.3

# Bounce settings
@export var bounce_force = 250.0
@export var small_bounce_force = 150.0

# State variables
var is_running = false
var is_jumping = false
var is_ducking = false
var can_move = true
var standing_still = false
var jump_hold_time = 0.0
var direction = 0 # -1 Left / 1 Right
var current_speed = Vector2(0,0)
var respawn_position = Vector2(0,0)

@export var last_frame_pos = Vector2(0,0)
@export var animation_speed = 12


# Initialization
func _ready():
	if Global.player_spawn_position:
		position = Global.player_spawn_position
		Global.player_spawn_position = null
	respawn_position = position

# Main physics logic
func _physics_process(delta):
	check_for_death()
	handle_gravity(delta)
	handle_movement(delta)
	handle_jump(delta)
	handle_actions()
	move_and_slide()

func check_for_death():
	if Global.kill_signal or position.y > 700:
		Global.kill_signal = false
		handle_death()

# Gravity logic
func handle_gravity(delta):
	if not is_on_floor():
		velocity.y = clamp(velocity.y + gravity * delta, -INF, max_fall_speed)

# Movement logic
func handle_movement(_delta):
	if not can_move:
		return

	is_running = Input.is_action_pressed("Run")
	var max_speed = max_walk_speed if not is_running else max_run_speed
	direction = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	standing_still = round(last_frame_pos.x*10)/10 == round(position.x*10)/10
	
	# Apply acceleration and clamp speed
	current_speed.x = clamp(current_speed.x + accel * direction * (2 if is_running else 1), -max_speed, max_speed)

	# Animation handling
	if direction != 0:
		play_run_animation(direction < 0)
	else:
		current_speed.x = lerp(current_speed.x, 0.0, friction)
		if is_on_floor() and abs(current_speed.x) < 20:
			$AnimationPlayer.stop()
			$Sprite2D.frame = 0

	velocity.x = current_speed.x
	last_frame_pos = position

func bounce(force: float = bounce_force, no_hold_force: float = small_bounce_force):
	print("Bounce with force: " + str(force))
	is_jumping = true
	jump_hold_time = 0.0
	velocity.y = -force
	$JumpAudio.play(0.1)

	small_jump_force = no_hold_force

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
		print(jump_hold_time)
		
		# Stop applying extra force if the jump button is released
		if not Input.is_action_pressed("Jump"):
			if jump_hold_time < min_jump_time:
				velocity.y = -small_jump_force
				is_jumping = false
			
		if not Input.is_action_pressed("Jump") and is_on_floor():
			is_jumping = false
			jump_hold_time = 0.0
			small_jump_force = default_jump_force

# Handle additional actions
func handle_actions():
	is_ducking = Input.is_action_pressed("Duck")
	$Sprite2D.frame = 6 if is_ducking else $Sprite2D.frame

	if Input.is_action_just_pressed("Reset"):
		handle_death()
		
# Play run animation
func play_run_animation(flip_h: bool):
	$Sprite2D.flip_h = flip_h
	$AnimationPlayer.speed_scale = 16 if is_running else animation_speed
	
	if not is_on_floor() and is_ducking:
		$AnimationPlayer.stop()
		return
		
	if abs(current_speed.x) > 1 and not is_ducking and not standing_still:
		$AnimationPlayer.play("Run")
	else:
		$AnimationPlayer.stop()

func handle_death():
	Global.PlayerLives -= 1
	if Global.PlayerLives>0:
		get_tree().reload_current_scene()
	else:
		get_tree().exit()
