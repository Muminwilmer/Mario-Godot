extends Area2D

@export var path_to_next_level = ""

func _on_body_entered(body):
	if (body.name == "Mario"):
		body.handle_death()
