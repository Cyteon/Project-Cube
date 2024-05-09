extends Node

# TODO: so uh better mod support?

# Called when the node enters the scene tree for the first time.

var modPath = OS.get_executable_path().get_base_dir() + "/mods/"

func _ready():
	
	if DirAccess.dir_exists_absolute(modPath):
		print("Mods folder found at %s" % modPath)
		
		for file in DirAccess.get_files_at(modPath):
			if file.ends_with(".pck"):
				print("Loading mod %s" % file)
				
				var success = ProjectSettings.load_resource_pack(modPath + file)
				
				# TODO: do something more with mod
				
				if success:
					var mod_script = load("res://mod/%s/mod.gd" % file.replace(".pck", ""))
					
					print("Author: %s, Name: %s, Version: %s" % [mod_script.author, mod_script.modName, mod_script.version])
				


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
