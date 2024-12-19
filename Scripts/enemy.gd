extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Movement settings
@export var max_walk_speed = 150.0
@export var max_fall_speed = 240.0
@export var accel = 14.0
@export var friction = 0.2
@export var running_multiplier = 2.5

# State variables
var is_running = false
var is_jumping = false
var jump_hold_time = 0.0
var current_speed = Vector2(0,0)
