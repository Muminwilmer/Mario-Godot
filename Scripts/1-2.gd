extends Node2D

var bullet_scene = load("res://ResourceScenes/Enemies/bullet.tscn")
var bulletList = []
 
var plant_scene = load("res://ResourceScenes/Enemies/plant.tscn")
var plantList = []

var pipe_scene = load("res://ResourceScenes/Functional/pipes.tscn")
var pipeList = []

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
	Global.time = 400
	
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
		
