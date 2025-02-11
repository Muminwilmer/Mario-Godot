extends Control

@export var ScenePath = ""

func _on_start_button_down():
	get_tree().change_scene_to_file(ScenePath)


func _on_quit_button_down():
	get_tree().quit()

var pipe_scene = load("res://ResourceScenes/pipes.tscn")
var pipeList = [
	{"position": Vector2(868, 576), "destination": Vector2(932, 16), "rotation": 0}, # Goto 1st secret
]

func _ready():
	Global.current_level = get_tree().current_scene.scene_file_path
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
