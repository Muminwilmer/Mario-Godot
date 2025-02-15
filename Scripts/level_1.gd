extends Node2D

var bullet_scene = load("res://ResourceScenes/Enemies/bullet.tscn")
var bulletList = [
	{"position": Vector2(1496, 520), "delay": 2.5, "direction": Vector2.RIGHT},
	
	{"position": Vector2(6568, 504), "delay": 4, "direction": Vector2.LEFT},
	{"position": Vector2(6600, 504), "delay": 4, "direction": Vector2.RIGHT},
	
	{"position": Vector2(6936, 376), "delay": 8, "direction": Vector2.LEFT},
	{"position": Vector2(6936, 392), "delay": 8, "direction": Vector2.LEFT},
	{"position": Vector2(6936, 408), "delay": 8, "direction": Vector2.LEFT},
	{"position": Vector2(6936, 424), "delay": 8, "direction": Vector2.LEFT},
	{"position": Vector2(6936, 440), "delay": 8, "direction": Vector2.LEFT},
	{"position": Vector2(6936, 456), "delay": 8, "direction": Vector2.LEFT},
	{"position": Vector2(6936, 472), "delay": 8, "direction": Vector2.LEFT},
]
 
var plant_scene = load("res://ResourceScenes/Enemies/plant.tscn")
var plantList = [
	{"position": Vector2(560, 480), "rotation": 0},
	{"position": Vector2(608, 480), "rotation": 0},
	{"position": Vector2(656, 480), "rotation": 0},
	{"position": Vector2(704, 480), "rotation": 0},
	{"position": Vector2(752, 480), "rotation": 0},
	{"position": Vector2(1152, 480), "rotation": 0}
]

var pipe_scene = load("res://ResourceScenes/Functional/pipes.tscn")
var pipeList = [
	{"position": Vector2(272, 500), "destination": Vector2(4010, 512), "rotation": 0}, # Goto 1st secret
	{"position": Vector2(3976, 512), "destination": Vector2(272, 400), "rotation": 90}, # Go back from 1st secret
	{"position": Vector2(3288, 512), "destination": Vector2(-18, 416), "rotation": 90, "goto_level": "res://LevelScenes/level_2.tscn"}, # Goto lvl 2
	{"position": Vector2(4448, 512), "destination": Vector2(6288, 400), "rotation": -90}, # Goto cave area
	{"position": Vector2(6272, 512), "destination": Vector2(4448, 488), "rotation": 90}, # Go back from cave area
	{"position": Vector2(6928, 512), "destination": Vector2(1696, 456), "rotation": 90}, # Goto after bullet jump
	{"position": Vector2(4976, 592), "destination": Vector2(6754, 576), "rotation": 90}, # Goto after bullet jump
	{"position": Vector2(6772, 576), "destination": Vector2(24, 512), "rotation": -90, "goto_level": "res://LevelScenes/level_3.tscn"}, # Goto lvl 3
]

func _physics_process(_delta):
	# Update the camera position
	var cameraPosition = Vector2($Mario.position.x + 180, 512)
	$Camera.position = cameraPosition

func start_bullets():
	for bullet_data in bulletList:
		var bullet_timer = Timer.new()
		bullet_timer.wait_time = bullet_data["delay"]
		bullet_timer.one_shot = false  # Keeps repeating forever
		bullet_timer.autostart = true  # Starts automatically
		bullet_timer.connect("timeout", Callable(self, "_spawn_bullet").bind(bullet_data))
		add_child(bullet_timer)

func _spawn_bullet(bullet_data):
	var bullet = bullet_scene.instantiate()
	bullet.position = bullet_data["position"]
	bullet.direction = bullet_data["direction"]
	add_child(bullet)

func spawn_plant():
	for plant_data in plantList:
		var plant = plant_scene.instantiate()
		
		plant.position = plant_data["position"]
		
		plant.rotation = plant_data["rotation"]
		
		add_child(plant)

func _ready():
	Global.current_level = get_tree().current_scene.scene_file_path

	# Iterate through vectorLists to instantiate pipes
	spawn_plant()
	start_bullets()
	
	for pipe_data in pipeList:
		var NewPipe = pipe_scene.instantiate()
		
		# Set the position of the pipe
		NewPipe.position = pipe_data["position"]
		NewPipe.rotation = deg_to_rad(pipe_data["rotation"])
		
		# Assign the destination as metadata or a property
		NewPipe.destination = pipe_data["destination"]
		
		# Optionally assign the next level as metadata or a property
		if "goto_level" in pipe_data:
			NewPipe.set_meta("goto_level", pipe_data["goto_level"])
		
		# Add the pipe to the scene
		add_child(NewPipe)
		

