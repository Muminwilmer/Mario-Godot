extends Camera2D

func _physics_process(_delta):
	var Mario = get_node("../Mario")
	
	#var snapping_y = 150
	#var snapped_y_pos = int((Mario.position.y - Mario.respawn.y) / snapping_y) * snapping_y + Mario.respawn.y
	
	# Update the camera position to snap when Mario crosses the 200-unit threshold.
	
	var cameraPosition = Vector2(Mario.position.x + 180, Mario.respawn_position.y)
	position = cameraPosition
