extends Area2D

@export var destination = Vector2(0, 0)



func _on_body_entered(body):
	if body.name == "Mario":
		if destination.x != 0:
			body.position.x = destination.x
			
		if destination.y != 0:
			body.position.y = destination.y
