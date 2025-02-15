extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# Movement settings
@export var walk_speed = 40.0
@export var max_fall_speed = 100.0


var last_frame_pos = Vector2()
var moving_left = false

func _physics_process(_delta):
	if not is_on_floor():
		velocity.y += gravity * _delta
	
	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed
			
	
	if round(last_frame_pos.x*10)/10 == round(position.x*10)/10:
		moving_left = not moving_left
		
	if moving_left == true:
		velocity.x = -walk_speed
		#$Sprite2D.flip_h = false
	else:
		velocity.x = walk_speed
		#$Sprite2D.flip_h = true
		
	last_frame_pos = position
		
	move_and_slide()
		


func _on_die_body_entered(body):
	if body.name == "Mario":
		if Global.player_type < 1:
			Global.player_type = 1
		queue_free()
