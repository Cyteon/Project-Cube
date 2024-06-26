extends Node

# TODO: Better mod support

# Called when the node enters the scene tree for the first time.

var modPath = OS.get_executable_path().get_base_dir() + "/mods/"
var modExtension = ".zip"

func _ready():
	
	if DirAccess.dir_exists_absolute(modPath):
		print("Mods folder found at %s" % modPath)
		
		for file in DirAccess.get_files_at(modPath):
			if file.ends_with(modExtension):
				print("----------")
				
				print("Loading mod %s" % file)
				
				var success = ProjectSettings.load_resource_pack(modPath + file)
				
				# TODO: do something more with mod
				
				if success:
					# FIXME: Not printing mod folder even tough its in the pck that was exported
					
					var config = ConfigFile.new()

					# Load data from a file.
					print("Loading manifest: res://mod/%s/manifest.cfg" % file.replace(modExtension, ""))
					var err = config.load("res://mod/%s/manifest.cfg" % file.replace(modExtension, ""))
					
					
					var author = config.get_value("mod", "author")
					var modName = config.get_value("mod", "name")
					var version = config.get_value("mod", "version")
					
					print("Author: %s, Name: %s, Version: %s" % [author, modName, version])
					
					var modFile = load("res://mod/%s/mod.gd" % file.replace(modExtension, ""))
					
					print("----------")
					
					modFile.ready()
				


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
