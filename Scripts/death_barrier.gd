extends Area2D

func _on_body_entered(body):
	if (body.name == "Mario"):
		Global.kill_signal = true
