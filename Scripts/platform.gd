extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Movement settings
@export var walk_speed = 30.0

var moving_up = false
var moving_left = false

@export var topY = 0
@export var lowY = 0
@export var leftX = 0
@export var rightX = 0
@export var instaTeleport = false
@export var vertical_distance = 0
@export var horizontal_distance = 0

var enable_vertical = true
var enable_horizontal = true

func _ready():
	if lowY == 0:
		lowY = position.y
	if topY == 0:
		topY = lowY - vertical_distance  # Vertical boundary

	if leftX == 0:
		leftX = position.x
	if rightX == 0:
		rightX = leftX + horizontal_distance  # Horizontal boundary

	# Disable movement if the distances are zero
	enable_vertical = abs(topY - lowY) > 1
	enable_horizontal = abs(rightX - leftX) > 1

func _physics_process(delta):
	# Handle vertical movement
	if enable_vertical:
		position.y += (-walk_speed if moving_up else walk_speed) * delta
		if position.y <= topY:
			moving_up = false
		elif position.y >= lowY:
			moving_up = true

	# Handle horizontal movement
	if enable_horizontal:
		position.x += (-walk_speed if moving_left else walk_speed) * delta
		if position.x <= leftX:
			moving_left = false
		elif position.x >= rightX:
			moving_left = true
	
