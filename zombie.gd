extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# Movement settings
@export var walk_speed = 60.0
@export var max_fall_speed = 100.0
@export var jump_force = 140

var wait_for_jump = 10
var last_jump = 0

var last_frame_pos = Vector2()
var moving_left = false
@export var animation_speed = 12


func _ready():
	$AnimationPlayer.speed_scale = animation_speed
	
	$AnimationPlayer.play("Walk")
	#start_pos = position
	
func _physics_process(_delta):
	if not is_on_floor():
		velocity.y += gravity * _delta
	
	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed
			
	
	if round(last_frame_pos.x*10)/10 == round(position.x*10)/10:
		print("hit wall")
		moving_left = not moving_left
		
	if moving_left == true:
		velocity.x = -walk_speed
		$Sprite2D.flip_h = true
	else:
		velocity.x = walk_speed
		$Sprite2D.flip_h = false
	if is_on_floor():
		last_jump += 1
	if last_jump >= wait_for_jump and is_on_floor():
		last_jump = 0
		velocity.y += -(randi()%100) -jump_force
		
	
		
	last_frame_pos = position
		
	#if position.x >= start_pos.x:
		#moving_left = true
	#elif position.x <= start_pos.x - max_move_from_start:
		#moving_left = false
		
	move_and_slide()
		


func _on_die_body_entered(body):
	if body.name == "Mario":
		queue_free()

func _on_attack_body_entered(body):
	if body.name == "Mario":
		Global.kill_signal = true
