extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var animation_speed = 16

func _ready():
	$AnimationPlayer.speed_scale = animation_speed
	$AnimationPlayer.play("Consume")
	await $AnimationPlayer.animation_finished
	
	Global.coins += 1
	queue_free()
