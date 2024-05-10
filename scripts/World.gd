extends Node3D

var modifiedBlocks = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$CanvasLayer/FPSCounter.text = "FPS: %s" % Engine.get_frames_per_second()


func _on_heightmap_generator_3d_chunk_generation_finished(chunk_position):
	$CanvasLayer/CreatingWorld.hide()
	# TODO: Make progressbar do something
