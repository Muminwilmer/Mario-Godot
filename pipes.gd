extends Area2D

@export var destination = Vector2(0, 0)

func _on_body_entered(body):
	if body.name == "Mario" and body.is_ducking:
		body.can_move = false

		#await get_tree().create_timer(1).timeout

		if has_meta("goto_level"):
			var level_path = get_meta("goto_level")

			# Save the destination in the global singleton
			Global.player_spawn_position = destination

			# Change to the next level
			get_tree().change_scene_to_file(level_path)
			
		body.position = destination
		body.can_move = true
