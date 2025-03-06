extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# Movement settings
@export var walk_speed = 100.0

var last_frame_pos = Vector2()
var moving_up = false
@export var animation_speed = 8


func _ready():
	$AnimationPlayer.speed_scale = animation_speed
	
func _physics_process(_delta):
	$AnimationPlayer.play("Walk")
	
	if round(last_frame_pos.y*10)/10 == round(position.y*10)/10:
		moving_up = not moving_up
		
	if moving_up == true:
		velocity.y = -walk_speed
	else:
		velocity.y = walk_speed
		
	last_frame_pos = position
		
	move_and_slide()
		


func _on_die_body_entered(body):
	Global.points += 100
	queue_free()

func _on_attack_body_entered(body):
	Global.kill_signal = 1
