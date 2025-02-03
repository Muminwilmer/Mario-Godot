extends Area2D

@export var path_to_next_level = ""
@export var give_life = false
@export var life_amount = 1

func _on_body_entered(body):
	if (body.name == "Mario"):
		if give_life:
			Global.PlayerLives += life_amount
		get_tree().change_scene_to_file(path_to_next_level)
