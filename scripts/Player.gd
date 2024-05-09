extends CharacterBody3D

@onready var Ray = $Camera3D/RayCast3D

const WALKING_SPEED : float = 3.0
const JUMP_VELOCITY : float = 6.0
const ACCEL : float = 0.35
const GRAVITY : float = 15.0

var input_dir : Vector2 = Vector2(0, 0)
var jump_input_buffer : int = 0
var coyote_buffer : int = 0

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
		
		if event.is_action_pressed("break"):
			collider.set_cell_item(
				collider.map_to_local(# Handle jump.
					Ray.get_collision_point() - Ray.get_collision_normal()
					),
				-1
			)
		elif event.is_action_pressed("place"):
			var blockId = 2 # TODO: Actual block ID logic
			
			collider.set_cell_item(
				collider.map_to_local(
					Ray.get_collision_point()
					),
				blockId
			)

func _physics_process(delta):
	# gravity
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	
	# tick down all the buffers by one frame
	if coyote_buffer > 0:
			coyote_buffer -= 1
	
	if jump_input_buffer > 0:
		jump_input_buffer -= 1
	
	# get movement dir
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	# interpolate velocity towards movement dir * speed
	velocity.x = lerp(velocity.x, direction.x * WALKING_SPEED, ACCEL)
	velocity.z = lerp(velocity.z, direction.z * WALKING_SPEED, ACCEL)
	move_and_slide()

func _process(_delta):
	input_dir = Input.get_vector("left", "right", "up", "down")
	if Input.is_action_just_pressed("jump"):
		# 7 frames of buffer time to hit jump early before hitting the floor
		jump_input_buffer = 7
		
		# check if player was on floor within the last 7 frames, if yes, jump
		if coyote_buffer > 0:
			jump()
	
	if is_on_floor():
		coyote_buffer = 7
		# check if jump has been pressed within the last 7 frames, if yes, jump
		if jump_input_buffer > 0:
			jump()

func jump():
	velocity.y = JUMP_VELOCITY
	coyote_buffer = 0
	jump_input_buffer = 0
