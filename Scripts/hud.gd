extends CanvasLayer

@export var parent_world = ""
@export var child_world = ""
@export var world_type = 0

func _ready():
	$WorldNum.text = parent_world+"-"+child_world

func _process(delta):
	$Points.text = str(Global.points)
	$Coins.text = str(Global.coins)
	
	
	Global.time -= 3 * delta
	
	if round(Global.time) < 0:
		Global.kill_signal = 2
	else:
		$TimeNum.text = str(round(Global.time))
