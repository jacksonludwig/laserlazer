class_name Player
extends CharacterBody2D

@export var speed: float = 300


func _physics_process(delta):
	# call `Input.get_action_strength()` to support analog movement.
	var direction := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

	# When aiming the joystick diagonally, the direction vector can have a length
	# greater than 1.0, making the character move faster than our maximum expected
	# speed. When that happens, we limit the vector's length to ensure the player
	# can't go beyond the maximum speed.
	if direction.length() > 1.0:
		direction = direction.normalized()

	velocity = direction * speed
	move_and_collide(velocity * delta)
