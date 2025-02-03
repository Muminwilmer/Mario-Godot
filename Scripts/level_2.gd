extends Node2D

# Counter for tracking ticks
var tick_counter = 0

var bullet_scene = load("res://ResourceScenes/bullet.tscn")
var bulletList = [
	#{"position": Vector2(1496, 520), "delay": 0, "left": false},
]

var pipeLoad = load("res://ResourceScenes/pipes.tscn")
var pipeList = [
	#{"position": Vector2(3288, 512), "destination": Vector2(-18, 416), "rotation": 90, "goto_level": "res://LevelScenes/level_2.tscn"},
]
	
func _physics_process(_delta):
	# Update the camera position
	var cameraPosition = Vector2($Mario.position.x + 180, 512)
	$Camera.position = cameraPosition

	# Increment the tick counter
	tick_counter += 1

	# Check if it's time to spawn a bullet
	if tick_counter >= 200:
		spawn_bullet()
		tick_counter = 0  # Reset the counter

func spawn_bullet():
	for bullet_data in bulletList:
		var bullet = bullet_scene.instantiate()
		
		bullet.position = bullet_data["position"]
		
		bullet.delay = bullet_data["delay"]
		
		bullet.moving_left = bullet_data["left"]
		
		add_child(bullet)


func _ready():
	# Iterate through vectorLists to instantiate pipes
	for pipe_data in pipeList:
		var NewPipe = pipeLoad.instantiate()
		
		# Set the position of the pipe
		NewPipe.position = pipe_data["position"]
		NewPipe.rotation = deg_to_rad(pipe_data["rotation"])
		
		# Assign the destination as metadata or a property
		NewPipe.destination = pipe_data["destination"]
		
		# Optionally assign the next level as metadata or a property
		if "goto_level" in pipe_data:
			NewPipe.set_meta("goto_level", pipe_data["goto_level"])
		
		# Add the pipe to the scene
		add_child(NewPipe)
		

