extends CharacterBody3D

@onready var Ray = $Camera3D/RayCast3D
@onready var HotBarContainer = $"../CanvasLayer/HotBarContainer"

const WALKING_SPEED : float = 3.0
const JUMP_VELOCITY : float = 6.0
const ACCEL : float = 0.35
const GRAVITY : float = 15.0

var inputDir : Vector2 = Vector2(0, 0)
var jumpInputBuffer : int = 0
var coyoteBuffer : int = 0

var currentHotBarSlot = 1

var hotBarContent = {}

func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:	
			rotate_y(-event.relative.x * 0.005)
			$Camera3D.rotate_x(-event.relative.y * 0.01)
			
			$Camera3D.rotation.x = clamp($Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90))
			
	if Ray.is_colliding():
		var collider = Ray.get_collider()
		
		if collider is GridMap:
			var normal = Ray.get_collision_normal()
			
			if event.is_action_pressed("break"):
				var mapCords = collider.map_to_local(
					Ray.get_collision_point() - normal*0.5
					)
				
				collider.set_cell_item(
					mapCords,
					-1
				)
				
				$"..".modifiedBlocks[mapCords] = -1
				
			elif event.is_action_pressed("place"):
				var blockId = 2 # TODO: Actual block ID logic
				
				var mapCords = collider.map_to_local(
					Ray.get_collision_point() + normal*0.5
					)
				
				collider.set_cell_item(
					mapCords,
					blockId
				)
				
				$"..".modifiedBlocks[mapCords] = blockId

func _physics_process(delta):
	# gravity
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	
	# tick down all the buffers by one frame
	if coyoteBuffer > 0:
			coyoteBuffer -= 1
	
	if jumpInputBuffer > 0:
		jumpInputBuffer -= 1
	
	# get movement dir
	var direction = (transform.basis * Vector3(inputDir.x, 0, inputDir.y)).normalized()
	# interpolate velocity towards movement dir * speed
	velocity.x = lerp(velocity.x, direction.x * WALKING_SPEED, ACCEL)
	velocity.z = lerp(velocity.z, direction.z * WALKING_SPEED, ACCEL)
	move_and_slide()

func get_number_input():
	if Input.is_action_just_pressed("hotbar1"):
		currentHotBarSlot = 1
	elif Input.is_action_just_pressed("hotbar2"):
		currentHotBarSlot = 2
	elif Input.is_action_just_pressed("hotbar3"):
		currentHotBarSlot = 3
	elif Input.is_action_just_pressed("hotbar4"):
		currentHotBarSlot = 4
	elif Input.is_action_just_pressed("hotbar5"):
		currentHotBarSlot = 5
	elif Input.is_action_just_pressed("hotbar6"):
		currentHotBarSlot = 6
	elif Input.is_action_just_pressed("hotbar7"):
		currentHotBarSlot = 7
	elif Input.is_action_just_pressed("hotbar8"):
		currentHotBarSlot = 8
	elif Input.is_action_just_pressed("hotbar9"):
		currentHotBarSlot = 9

func _process(_delta):
	inputDir = Input.get_vector("left", "right", "up", "down")
	if Input.is_action_just_pressed("jump"):
		# 7 frames of buffer time to hit jump early before hitting the floor
		jumpInputBuffer = 7
		
		# check if player was on floor within the last 7 frames, if yes, jump
		if coyoteBuffer > 0:
			jump()
	
	if is_on_floor():
		coyoteBuffer = 7
		# check if jump has been pressed within the last 7 frames, if yes, jump
		if jumpInputBuffer > 0:
			jump()
			
			
	get_number_input()
	var hotBarSlotPos = HotBarContainer.get_child(currentHotBarSlot-1).global_position
	$"../CanvasLayer/SelectedMarker".position = hotBarSlotPos

func jump():
	velocity.y = JUMP_VELOCITY
	coyoteBuffer = 0
	jumpInputBuffer = 0
