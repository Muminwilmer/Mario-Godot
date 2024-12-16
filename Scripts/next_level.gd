extends Area2D

@export var path_to_next_level = ""

func _on_body_entered(body):
	if (body.name == "Mario"):
		get_tree().change_scene_to_file(path_to_next_level)
