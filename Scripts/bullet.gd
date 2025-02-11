extends CharacterBody2D

@export var walk_speed = 80.0
@export var max_fall_speed = 100.0

var last_frame_pos = Vector2()
@export var direction: Vector2 = Vector2.RIGHT  # Default direction
@export var damage = 1

func _physics_process(_delta):
	if last_frame_pos == position:
		queue_free()

	# Apply movement
	velocity = direction.normalized() * walk_speed

	# Flip horizontally based on direction (left or right movement)
	if direction.x < 0:
		$Sprite2D.flip_h = false  # Flip sprite when moving left
	else:
		$Sprite2D.flip_h = true  # Don't flip sprite when moving right

	# Apply rotation for up/down movement
	if direction.y < 0:
		rotation = deg_to_rad(-90)  # Point up
	elif direction.y > 0:
		rotation = deg_to_rad(90)  # Point down
	else:
		rotation = 0  # No rotation when moving horizontally

	last_frame_pos = position
	move_and_slide()

func _on_die_body_entered(body):
	if body.name == "Mario":
		body.bounce(400, 300)
		queue_free()

func _on_attack_body_entered(body):
	if body.name == "Mario":
		Global.kill_signal = damage
