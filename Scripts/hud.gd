extends CanvasLayer

@export var parent_world = ""
@export var child_world = ""
@export var world_type = 0

@export var time = 400
# Called when the node enters the scene tree for the first time.
func _ready():
	$WorldNum.text = parent_world+"-"+child_world

func _process(delta):
	$Points.text = str(Global.points)
	$Coins.text = str(Global.coins)
	
	
	time -= 4 * delta
	
	if round(time) < 0:
		Global.kill_signal = 2
	else:
		$TimeNum.text = str(round(time))
