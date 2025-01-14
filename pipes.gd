extends Area2D

@export var destination = Vector2(0,0)

func _on_body_entered(body):
	if (body.name == "Mario" && body.is_ducking):
		body.position = destination
