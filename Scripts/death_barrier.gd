extends Area2D

@export var damage = 2

func _on_body_entered(body):
	if (body.name == "Mario"):
		Global.kill_signal = damage
