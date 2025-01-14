extends Node2D

func _physics_process(_delta):
	#var snapping_y = 150
	#var snapped_y_pos = int((Mario.position.y - Mario.respawn.y) / snapping_y) * snapping_y + Mario.respawn.y
	
	# Update the camera position to snap when Mario crosses the 200-unit threshold.
	
	var cameraPosition = Vector2($Mario.position.x + 180, $Mario.respawn_position.y)
	$Camera.position = cameraPosition

func _ready():
	var pipeLoad = load("res://ResourceScenes/pipes.tscn")
	var vectorLists = [
		{"position": Vector2(272, 500), "destination": Vector2(4010, 512)},
		{"position": Vector2(3980, 512), "destination": Vector2(272, 440)},
		{"position": Vector2(480, 512), "destination": Vector2(700, 300)}
	]
	
	# Iterate through vectorLists to instantiate pipes
	for pipe_data in vectorLists:
		var NewPipe = pipeLoad.instantiate()
		
		# Set the position of the pipe
		NewPipe.position = pipe_data["position"]
		
		# Assign the destination as metadata or a property
		NewPipe.destination = pipe_data["destination"]
		
		# Add the pipe to the scene
		add_child(NewPipe)
