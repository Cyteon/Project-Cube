extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_heightmap_generator_3d_chunk_generation_finished(chunk_position):
	$CanvasLayer/CreatingWorld.hide()
	
	# TODO: Make progressbar do something
