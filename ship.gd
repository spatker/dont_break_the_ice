extends CharacterBody2D

# based mostly on https://www.youtube.com/watch?v=mJ1ZfGDTMCY

const ship_length = 150
const steering_angle = 8
const engine_power = 100
const friction = -0.2
const drag = -0.001

var acceleration = Vector2()
var steer_direction
var collided = false
var health = 6

signal health_depleted
signal died

func _physics_process(delta):
	acceleration = Vector2.ZERO
	get_input()
	calculate_friction()
	calculate_steering(delta)
	
	var prev_collided = collided
	var collision = move_and_collide(velocity * delta)
	if collision:
		collided = true
		var id = collision.get_collider_id()
		var inst = instance_from_id(id)
		inst.apply_impulse(-collision.get_normal(), collision.get_position())
	else:
		collided = false
	if collided and not prev_collided:
		health -= 1
		emit_signal("health_depleted")
		if health == 0:
			emit_signal("died")


func calculate_friction():
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	acceleration += friction_force + drag_force

func calculate_steering(delta):
	velocity += acceleration * delta
	if velocity.length() <= 0.1:
		velocity = Vector2.ZERO
	var rear = position - transform.x * ship_length / 2.0
	var front = position + transform.x * ship_length / 2.0
	rear += velocity * delta
	front += velocity.rotated(steer_direction) * delta
	var new_heading = (front - rear).normalized()
	var d = new_heading.dot(velocity)
	if d > 0:
		velocity = new_heading * velocity.length()
	else:
		velocity = -new_heading * velocity.length()
	rotation = new_heading.angle()

func get_input():
	var turn = 0
	if Input.is_action_pressed("steer_right"):
		turn += 1
	if Input.is_action_pressed("steer_left"):
		turn -= 1
	steer_direction = turn * deg_to_rad(steering_angle)
	if Input.is_action_pressed("accelerate"):
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("brake"):
		acceleration = transform.x * -engine_power
