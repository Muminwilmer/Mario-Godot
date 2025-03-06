extends CharacterBody2D

@export var type := "Normal" # Castle, Normal, Underwater
@export var item := 0 # 0 = None, 1 = Mushroom, 2 = 1up, 3 = Fire Flower, 4 = Star
@export var invis := false
@export var fakeBrick := false
@export var spawn_offset := 16
var used := false # Track if the block has been hit

func _ready():
	if invis:
		visible = false
		
	if fakeBrick:
		match type:
			"Normal":
				$Sprite2D.frame = 4
			"Underwater":
				$Sprite2D.frame = 9
			"Castle":
				$Sprite2D.frame = 14
	else:
		$AnimationPlayer.play(type)

func _on_open_body_entered(body):
	if not used:
		if body.is_jumping or type == "Underwater" and body.is_swimming:
			used = true
			$AnimationPlayer.stop()
			
			match type:
				"Normal":
					$Sprite2D.frame = 3
				"Underwater":
					$Sprite2D.frame = 8
				"Castle":
					$Sprite2D.frame = 13
			
			spawn_item()

func spawn_item():
	var item_scenes = {
		1: "res://ResourceScenes/PowerUps/mushroom.tscn",
		2: "res://ResourceScenes/PowerUps/1up.tscn",
		3: "res://ResourceScenes/PowerUps/fire_flower.tscn",
		4: "res://ResourceScenes/PowerUps/star.tscn",
	}

	if item in item_scenes:
		var powerup = load(item_scenes[item]).instantiate()
		powerup.position = position - Vector2(0, spawn_offset)
		await get_tree().process_frame
		get_parent().add_child(powerup)
		Global.points += 1000
	else:
		var coin = preload("res://ResourceScenes/PowerUps/coin.tscn").instantiate()
		coin.position = position - Vector2(0, spawn_offset)
		await get_tree().process_frame
		get_parent().add_child(coin)
		Global.points += 200
		
	if invis:
		visible = true
