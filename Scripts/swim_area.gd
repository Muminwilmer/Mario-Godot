extends Area2D

func _on_body_entered(body):
	if (body.name == "Mario"):
		body.is_swimming = true



func _on_body_exited(body):
	if (body.name == "Mario"):
		body.is_swimming = false
