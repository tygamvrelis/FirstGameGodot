extends CharacterBody2D

# Jump code from:
# - https://youtu.be/IOe1aGY6hXA?si=ZMlx8O9W_kbj4tO1
# - https://gist.github.com/sjvnnings/5f02d2f2fc417f3804e967daa73cccfd
var jump_height: float = 35
var jump_time_to_peak: float = 0.4
var jump_time_to_descent: float = 0.35

@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

var max_air_jumps: int = 0
var num_air_jumps: int = 0

var running_speed: float = 150.0

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var jump_sound = $JumpSound
@onready var run_sound = $RunSound

func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func jump():
	num_air_jumps = 0
	velocity.y = jump_velocity
	jump_sound.play() 

func air_jump():
	num_air_jumps += 1
	velocity.y = jump_velocity
	jump_sound.play() 

func handle_movement_collision(collision: KinematicCollision2D):
	if collision.get_collider() is Block:
		var collision_angle = rad_to_deg(collision.get_angle())
		if roundf(collision_angle) == 180:
			(collision.get_collider() as Block).bump()

func _physics_process(delta):
	# Add the gravity.
	velocity.y += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			jump()
		elif num_air_jumps < max_air_jumps:
			air_jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip sprite.
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	
	# Play animations.
	if not is_on_floor():
		animated_sprite_2d.play("jump")
	elif direction == 0:
		animated_sprite_2d.play("idle")
	else:
		animated_sprite_2d.play("run")

	# Movement.
	if direction:
		velocity.x = direction * running_speed
	else:
		velocity.x = move_toward(velocity.x, 0, running_speed)

	var collision = get_last_slide_collision()
	if collision != null:
		handle_movement_collision(collision)

	move_and_slide()

func powerup_air_jump():
	max_air_jumps = 1
