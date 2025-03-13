extends Control

func _ready():
	await get_tree().create_timer(2).timeout
	Global._reset()
	get_tree().change_scene_to_file("res://InterfaceScenes/start_menu.tscn")
