extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Lives.text = str(Global.PlayerLives)
	await get_tree().create_timer(0.8).timeout
	get_tree().change_scene_to_file(Global.current_level)
