extends Area2D

@export var path_to_next_level: String = ""
@export var give_life: bool = false
@export var life_amount: int = 1
@export var keep_x: bool = false
@export var next_level_y: int = 200

func _on_body_entered(body):
	if body.name == "Mario":
		if path_to_next_level.is_empty():
			print("No next level set. Skipping transition.")
			return  # No need to return a value
		
		if give_life:
			Global.PlayerLives += life_amount
			print("Player gained", life_amount, "lives. Total lives:", Global.PlayerLives)
			
		if life_amount >= 0:
			Global.points += (round(Global.time/3)) * 50
			
		if keep_x:
			Global.player_spawn_position = Vector2(body.position.x, next_level_y)
			print("Setting spawn position to:", Global.player_spawn_position)

		var error = get_tree().change_scene_to_file(path_to_next_level)
		if error != OK:
			print("Error changing scene:", error)
