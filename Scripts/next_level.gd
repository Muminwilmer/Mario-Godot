extends Area2D

@export var path_to_next_level = ""
@export var give_life = false
@export var life_amount = 1
@export var keep_x = false
@export var next_level_y = 200


func _on_body_entered(body):
	if (body.name == "Mario"):
		if give_life:
			Global.PlayerLives += life_amount

		if keep_x:
			
			Global.player_spawn_position = Vector2(body.position.x, next_level_y)

		get_tree().change_scene_to_file(path_to_next_level)
