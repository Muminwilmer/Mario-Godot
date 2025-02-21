extends Node

var PlayerLives = 3
var player_spawn_position = Vector2(0,0)
var player_type = 0  # 0 - Small, 1 - Big
var player_ability # 0 - Normal, 1 - idk
var current_sprite = null
var kill_signal = 0
var current_level

var coins = 0
var points = 0
var time = 400

func _ready():
	pass

func _process(_delta):
	pass
