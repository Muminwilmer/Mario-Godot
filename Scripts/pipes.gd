extends Area2D

@export var destination = Vector2(0, 0)
var inside = false
var mario = null

func _physics_process(_delta):
	if mario != null:
		if inside and mario.standing_still and mario.is_ducking:
			mario.can_move = false
			if has_meta("goto_level"):
				var level_path = get_meta("goto_level")

				# Save the destination in the global singleton
				Global.player_spawn_position = destination

				# Change to the next level
				get_tree().change_scene_to_file(level_path)
			else:
				mario.position = destination
				await get_tree().create_timer(0.4).timeout
				mario.can_move = true
	
func _on_body_entered(body):
	if body.name == "Mario":
		inside = true
		mario = body

func _on_body_exited(body):
	if body.name == "Mario":
		inside = false
