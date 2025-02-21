extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# Movement settings
@export var walk_speed = 30.0

var last_frame_pos = Vector2()
var moving_up = false

@export var topY = 0
@export var lowY = 0
@export var instaTeleport = false
@export var distance = 0

func _ready():
	if lowY == 0:
		lowY = position.y
	
	if topY == 0:
		topY = lowY - distance #Kill me
		
		
func _physics_process(_delta):
	position.y += (-walk_speed if moving_up else walk_speed) * _delta

	if position.y <= topY:
		#if instaTeleport:
			#position.y = lowY  # Instantly teleport to lowY
		#else:
		moving_up = false  # Start moving up

	elif position.y >= lowY:
		moving_up = true
		
	#move_and_slide()
