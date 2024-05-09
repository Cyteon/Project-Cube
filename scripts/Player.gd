extends CharacterBody3D

@onready var Ray = $Camera3D/RayCast3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

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
				collider.map_to_local(
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
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
