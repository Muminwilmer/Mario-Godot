extends Node2D

var bullet_scene = load("res://ResourceScenes/Enemies/bullet.tscn")
var bulletList = [
	{"position": Vector2(648, 550), "delay": 1.2, "direction": Vector2.UP},
	{"position": Vector2(680, 550), "delay": 1.2, "direction": Vector2.UP},
	
	{"position": Vector2(648, 312), "delay": 1.2, "direction": Vector2.DOWN},
	{"position": Vector2(680, 312), "delay": 1.2, "direction": Vector2.DOWN},
	
	{"position": Vector2(2552, 504), "delay": 5, "direction": Vector2.LEFT},
	{"position": Vector2(2552, 488), "delay": 5, "direction": Vector2.LEFT},
	{"position": Vector2(2552, 424), "delay": 5, "direction": Vector2.LEFT},
	{"position": Vector2(2552, 408), "delay": 5, "direction": Vector2.LEFT},
	{"position": Vector2(2552, 392), "delay": 5, "direction": Vector2.LEFT},
	
	{"position": Vector2(2728, 552), "delay": 1.5, "direction": Vector2.RIGHT},
]

var plant_scene = load("res://ResourceScenes/Enemies/plant.tscn")
var plantList = [
]

var pipe_scene = load("res://ResourceScenes/Functional/pipes.tscn")
var pipeList = [
	{"position": Vector2(704, 304), "destination": Vector2(2240, 560), "rotation": 180},
	{"position": Vector2(2208, 560), "destination": Vector2(704, 344), "rotation": 180},
	{"position": Vector2(2640, 560), "destination": Vector2(1248, 328), "rotation": 180},
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
		

