extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var small_jump = 400
@export var hold_jump = 600

@export var animation_speed = 12

func _ready():
	$AnimationPlayer.speed_scale = animation_speed
	$Sprite2D.frame = 1

func _on_bounce_body_entered(body):
	if body.name == "Mario":
		$AnimationPlayer.play("Bounce")
		body.bounce(hold_jump, small_jump)
		await $AnimationPlayer.animation_finished
		$Sprite2D.frame = 1
