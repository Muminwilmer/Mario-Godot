extends Node2D

func _physics_process(_delta):
	#var snapping_y = 150
	#var snapped_y_pos = int((Mario.position.y - Mario.respawn.y) / snapping_y) * snapping_y + Mario.respawn.y
	
	# Update the camera position to snap when Mario crosses the 200-unit threshold.
	
	var cameraPosition = Vector2($Mario.position.x + 180, 512)
	$Camera.position = cameraPosition
	
	
func _ready():
	var pipeLoad = load("res://ResourceScenes/pipes.tscn")
	var vectorLists = [
	]

	# Iterate through vectorLists to instantiate pipes
	for pipe_data in vectorLists:
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
