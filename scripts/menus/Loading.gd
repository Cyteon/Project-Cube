extends Control

var targetScene = "res://scenes/World.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	ResourceLoader.load_threaded_request(targetScene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var progress = []

	var status = ResourceLoader.load_threaded_get_status(targetScene, progress)
	$VBoxContainer/ProgressBar.value = progress[0]*100
	
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(targetScene))
	elif status == ResourceLoader.THREAD_LOAD_FAILED:
		# TODO: Return to menu
		$VBoxContainer/Label.text = "World Loading Failed"
