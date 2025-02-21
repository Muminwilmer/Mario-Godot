extends Label

func _process(_delta):
	var lives = Global.PlayerLives
	if (lives < 3):
		text = "Life:"+str(Global.PlayerLives)
