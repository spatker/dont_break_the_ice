extends CharacterBody2D


const SPEED = 300.0
const ACCELERATE_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):

	# Handle accelerate.
	if Input.is_action_just_pressed("accelerate"):
		velocity.y = ACCELERATE_VELOCITY

	# Get the input direction and handle the movement.
	var direction = Input.get_axis("steer_left", "steer_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_area_2d_body_entered(body):
	pass


func _on_area_2d_area_entered(area):
	print_debug(area.name)
