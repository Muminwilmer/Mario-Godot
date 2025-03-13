extends Node

var PlayerLives : int = 3
var player_spawn_position = Vector2(0,0)
var player_type = 0  # 0 - Small, 1 - Big
#var player_ability # 0 - Normal, 1 - idk
var current_sprite = "res://InterfaceScenes/start_menu.tscn"
var kill_signal = 0
var current_level

var coins : int = 0
var points : int = 0
var time : float = 400

func _reset():
	PlayerLives = 3
	player_spawn_position = Vector2(0,0)
	player_type = 0  # 0 - Small, 1 - Big
	#var player_ability # 0 - Normal, 1 - idk
	current_sprite = "res://InterfaceScenes/start_menu.tscn"
	kill_signal = 0
	current_level = null
	coins = 0
	points = 0
	time = 400
