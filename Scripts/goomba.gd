extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# Movement settings
@export var walk_speed = 60.0
@export var max_fall_speed = 100.0

@export var suicidal := false
@export var damage := 1

var last_frame_pos = Vector2()
var moving_left = false
@export var animation_speed = 6


func _ready():
	$AnimationPlayer.speed_scale = animation_speed
	
func _physics_process(_delta):
	#if not $Seen.is_on_screen():
		#return
	
	$AnimationPlayer.play("Walk")
	if not is_on_floor():
		velocity.y += gravity * _delta
		
	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed
			
	
	if round(last_frame_pos.x*10)/10 == round(position.x*10)/10:
		moving_left = not moving_left
		
	if not $OneTile.is_colliding() and not $TwoTile.is_colliding() and not suicidal:
		moving_left = not moving_left
		
	if moving_left == true:
		velocity.x = -walk_speed
		$Sprite2D.flip_h = false
		$OneTile.position.x = -16
		$TwoTile.position.x = -16
	else:
		velocity.x = walk_speed
		$Sprite2D.flip_h = true
		$OneTile.position.x = 16
		$TwoTile.position.x = 16
		
	last_frame_pos = position
		
	move_and_slide()
		


func _on_die_body_entered(body):
	body.bounce(300, 200)
	Global.points += 100
	queue_free()

func _on_attack_body_entered(body):
	Global.kill_signal = damage
