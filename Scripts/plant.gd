extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var animation_speed = 4

var tick_counter = 0
var spawn_location = null

func _ready():
	$AnimationPlayer.speed_scale = animation_speed
	$AnimationPlayer.play("Eat")
	spawn_location = position
	position = Vector2(0,0)
	self.visible = false

func _physics_process(_delta):
	tick_counter += 1
	
	if tick_counter > 200:
		position = spawn_location
		self.visible = true
	
	if tick_counter > 300:
		position = Vector2(0,0)
		self.visible = false
		tick_counter = 0
	
	

func _on_attack_body_entered(body):
	Global.kill_signal = 1


func _on_die_body_entered(body):
	Global.points += 200
	queue_free()
