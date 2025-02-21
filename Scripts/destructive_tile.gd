extends CharacterBody2D

@export var framecoords = Vector2(9, 0)

func _ready():
	$Sprite2D.frame_coords = framecoords

func _on_destroy_body_entered(body):
	if body.name == "Mario":
		if body.is_jumping or body.is_swimming:
			print("Destroying block at " + str(position))
			Global.points += 50
			queue_free()
