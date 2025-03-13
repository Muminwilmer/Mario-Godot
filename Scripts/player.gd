extends CharacterBody2D

# --- Physics Constants ---
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# --- Movement Settings ---
@export var max_walk_speed = 150.0
@export var max_run_speed = 220.0
@export var max_fall_speed = 240.0
@export var acceleration = 15.0
@export var friction = 0.2
@export var running_multiplier = 2.0

# --- Jump Settings ---
@export var jump_force = 400.0
var small_jump_force = 0
@export var default_jump_force = 100.0
@export var min_jump_time = 0.3

# --- Bounce Settings ---
@export var bounce_force = 250.0
@export var small_bounce_force = 150.0

# --- State Variables ---
var is_running = false
var is_jumping = false
var is_ducking = false
@export var is_swimming = false
var can_move := true
var standing_still = false
var jump_hold_time = 0.0
var direction = 0  # -1 Left / 1 Right
var current_speed = Vector2.ZERO
var respawn_position = Vector2.ZERO

@export var last_frame_pos = Vector2.ZERO
@export var animation_speed = 12
@export var jump_volume = -25

var can_die = {"invincible": false, "duration":0, "count": 0}

# --- Initialization ---
func _ready():
	#if Global.player_type == 0:

	if Global.player_spawn_position:
		position = Global.player_spawn_position
		Global.player_spawn_position = null
		
	respawn_position = position
	$JumpAudio.volume_db = jump_volume
	
	if Global.PlayerLives < 0:
		get_tree().quit()

# --- Main Physics Logic ---
func _physics_process(delta):
	check_invincibility(delta)
	check_for_death()
	check_player_type()
	handle_gravity(delta)
	handle_movement(delta)
	handle_jump(delta)
	handle_actions()
	if is_inside_tree():
		move_and_slide()

# --- Invincibility Logic ---
func check_invincibility(delta):
	if can_die["invincible"]:
		can_die["count"] += delta
		if can_die["count"] >= can_die["duration"]:
			can_die["invincible"] = false
			can_die["count"] = 0


# --- Hide/Show the sprites ---
func check_player_type():
	if Global.player_type == 1:
		# Large
		$SmallSprite.visible = false
		$SmallHitbox.disabled = true
		$LargeSprite.visible = true
		$LargeHitbox.disabled = false
		Global.current_sprite = $LargeSprite
	elif Global.player_type == 0:
		# Small
		$LargeSprite.visible = false
		$LargeHitbox.disabled = true
		$SmallSprite.visible = true
		$SmallHitbox.disabled = false
		Global.current_sprite = $SmallSprite
	else:
		print("Player type is invalid. Resetting to 0")
		Global.player_type = 0
		Global.current_sprite = $SmallSprite

# --- Death Handling ---
func check_for_death():
	if Global.kill_signal or position.y > 700:
		handle_death()

func handle_death():
	if not can_die["invincible"] or Global.kill_signal > 1:
		Global.player_type -= Global.kill_signal

		Global.kill_signal = 0
		
		can_die["invincible"] = true
		can_die["duration"] = 1
		can_die["count"] = 0
		
		if Global.player_type < 0:
			Global.PlayerLives -= 1
			if Global.PlayerLives > 0:
				get_tree().change_scene_to_file("res://InterfaceScenes/death_screen.tscn")
			else:
				get_tree().change_scene_to_file("res://InterfaceScenes/gameover.tscn")
	else:
		Global.kill_signal = 0

# --- Gravity Handling ---
func handle_gravity(delta):
	if not can_move:
		return
	
	if is_swimming:
		velocity.y = clamp(velocity.y + gravity * delta, -INF, 10)
	elif not is_on_floor():
		velocity.y = clamp(velocity.y + gravity * delta, -INF, max_fall_speed)

# --- Movement Handling ---
func handle_movement(_delta):
	if not can_move:
		velocity = Vector2(0,0)
		return

	is_running = Input.is_action_pressed("Run")
	direction = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	standing_still = is_standing_still()

	var max_speed = max_run_speed if is_running else max_walk_speed
	current_speed.x = clamp(current_speed.x + acceleration * direction * (2 if is_running else 1), -max_speed, max_speed)

	handle_animation()
	velocity.x = current_speed.x
	last_frame_pos = position

func is_standing_still() -> bool:
	return round(last_frame_pos.x * 10) / 10 == round(position.x * 10) / 10

# --- Jump Handling ---
func handle_jump(delta):
	if not can_move:
		return
	
	if is_swimming:
		handle_swim_jump()
	else:
		handle_ground_jump(delta)

func handle_swim_jump():
	if Input.is_action_pressed("Jump"):
		velocity.y = -max_walk_speed
		direction = Input.get_action_strength("Right") - Input.get_action_strength("Left")
		play_swim_animation(direction < 0, "Y")

func handle_ground_jump(delta):
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		start_jump()
	
	if is_jumping:
		process_jump_hold(delta)


func start_jump():
	is_jumping = true
	jump_hold_time = 0.0
	velocity.y = -jump_force
	Global.current_sprite.frame = 5
	$JumpAudio.play(0.14)

func process_jump_hold(delta):
	jump_hold_time += delta
	
	if not Input.is_action_pressed("Jump") and jump_hold_time < min_jump_time and jump_hold_time > 0.1:
		velocity.y = -small_jump_force
		is_jumping = false

	if not Input.is_action_pressed("Jump") and is_on_floor():
		is_jumping = false
		jump_hold_time = 0.0
		small_jump_force = default_jump_force

# --- Bounce Handling ---
func bounce(force: float = bounce_force, no_hold_force: float = small_bounce_force):
	is_jumping = true
	jump_hold_time = 0.0
	velocity.y = -force
	small_jump_force = no_hold_force
	$JumpAudio.play(0.14)


# --- Action Handling ---
func handle_actions():
	is_ducking = Input.is_action_pressed("Duck")
	if is_ducking and is_swimming:
		velocity.y = max_walk_speed
	else:
		if Global.player_type == 1:
			Global.current_sprite.frame = 6 if is_ducking else Global.current_sprite.frame
		elif Global.player_type == 0:
			Global.current_sprite.frame = 0 if is_ducking else Global.current_sprite.frame

	if Input.is_action_just_pressed("Reset"):
		Global.player_type = -1
		handle_death()

# --- Animation Handling ---
func handle_animation():
	if direction != 0:
		if is_swimming and not is_on_floor():
			play_swim_animation(direction < 0, "X")
		else:
			play_run_animation(direction < 0)
	else:
		current_speed.x = lerp(current_speed.x, 0.0, friction)
		if is_on_floor() and abs(current_speed.x) < 20:
			$AnimationPlayer.stop()
			Global.current_sprite.frame = 0
		elif is_swimming and abs(current_speed.x) < 20:
			if Global.player_type == 1:
				$AnimationPlayer.play("BigMarioSwimY")
			else:
				$AnimationPlayer.play("SmallMarioSwimY")

func play_run_animation(flip_h: bool):
	Global.current_sprite.flip_h = flip_h
	$AnimationPlayer.speed_scale = 16 if is_running else animation_speed

	if not is_on_floor() and is_ducking:
		$AnimationPlayer.stop()
		return

	if abs(current_speed.x) > 1 and not is_ducking and not standing_still:
		if Global.player_type == 1:
			$AnimationPlayer.play("BigMarioRun")
		else:
			$AnimationPlayer.play("SmallMarioRun")
	else:
		$AnimationPlayer.stop()

func play_swim_animation(flip_h: bool, dir):
	Global.current_sprite.flip_h = flip_h
	$AnimationPlayer.speed_scale = 16 if is_running else animation_speed

	if is_on_floor():
		play_run_animation(flip_h)
		return

	if abs(current_speed.x) > 1 and dir == "X" and not standing_still:
		if Global.player_type == 1:
			$AnimationPlayer.play("BigMarioSwimX")
		else:
			$AnimationPlayer.play("SmallMarioSwimX")
	else:
		if Global.player_type == 1:
			$AnimationPlayer.play("BigMarioSwimY")
		else:
			$AnimationPlayer.play("SmallMarioSwimY")
			
func _usedStar():
	can_die["invincible"] = true
	can_die["duration"] = 10
	can_die["count"] = 0

	var elapsed_time = 0.0  # Track how long the effect is active
	var max_time = 10.0  # Star lasts 10 seconds
	var shader_material = Global.current_sprite.material  # Get the shader material
	
	while elapsed_time < max_time:
		elapsed_time += get_process_delta_time()
		shader_material.set_shader_parameter("star_timer", elapsed_time)
		
		# Stops data.tree null error when changing maps
		if is_inside_tree():
			await get_tree().process_frame  # Wait for next frame
		else:
			shader_material.set_shader_parameter("star_timer", 0.0)
			return
	
	# Reset Mario's color when the star effect ends
	shader_material.set_shader_parameter("star_timer", 0.0)
