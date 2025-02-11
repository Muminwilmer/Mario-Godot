extends CharacterBody2D

@export var type := "Normal" # Castle, Normal, Underwater
@export var item := 0 # 0 = None, 1 = Mushroom, 2 = Fire Flower, 3 = Star

var used := false # Track if the block has been hit

func _ready():
	$AnimationPlayer.play(type)

func _on_open_body_entered(body):
	if body.name == "Mario" and body.is_jumping and not used:
		used = true
		$AnimationPlayer.stop()
		
		match type:
			"Normal":
				$Sprite2D.frame = 3
			"Castle":
				$Sprite2D.frame = 7
			"Underwater":
				$Sprite2D.frame = 11
		
		#spawn_item()

#func spawn_item():
	#if item == 1:
		#var mushroom = preload("res://mushroom.tscn").instantiate()
		#mushroom.position = position - Vector2(0, 16)
		#get_parent().add_child(mushroom)
	#elif item == 2:
		#var flower = preload("res://flower.tscn").instantiate()
		#flower.position = position - Vector2(0, 16)
		#get_parent().add_child(flower)
	#elif item == 3:
		#var star = preload("res://star.tscn").instantiate()
		#star.position = position - Vector2(0, 16)
		#get_parent().add_child(star)
