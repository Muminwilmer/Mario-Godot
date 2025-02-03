extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Movement settings
@export var walk_speed = 80.0
@export var max_fall_speed = 100.0

var last_frame_pos = Vector2()
var moving_left = false
@export var animation_speed = 4
var delay = 0

func _physics_process(_delta):
	
	if round(last_frame_pos.x*10)/10 == round(position.x*10)/10:
		queue_free()
		
	if moving_left == true:
		velocity.x = -walk_speed
		$Sprite2D.flip_h = false
	else:
		velocity.x = walk_speed
		$Sprite2D.flip_h = true
		
	last_frame_pos = position
		
	move_and_slide()
		


func _on_die_body_entered(body):
	if body.name == "Mario":
		body.bounce(400, 300)
		queue_free()

func _on_attack_body_entered(body):
	if body.name == "Mario":
		Global.kill_signal = true
