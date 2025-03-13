extends Control


func _ready():
	$Points.text += str(Global.points)
	$Sprite2D/Coins.text = str(Global.coins)
	$Lives.text = str(Global.PlayerLives)
