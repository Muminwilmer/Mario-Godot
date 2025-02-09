extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Lives.text = str(Global.PlayerLives)
	await get_tree().create_timer(2.5).timeout
	get_tree().change_scene_to_file(Global.current_level)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
