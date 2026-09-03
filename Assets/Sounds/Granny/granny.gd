const SPEED: float = 5.0
const DECELERATION: float = 20.0   
const JUMP_VELOCITY: float = 16


@onready var jump_sound: AudioStreamPlayer = $JumpSound


func _physics_process(delta: float) -> void:
	check_landing()
	apply_gravity(delta)
	handle_jump()
	handle_movement(delta)
	move_and_slide()


func handle_movement(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("m_left", "m_right", "m_fwd", "m_back")
	var direction: Vector3 = Vector3(input_dir.x, 0.0, input_dir.y)
	debug_label.text = "input: (%.1v)\ndir: (%.1v)" % [input_dir, direction]

	if direction.length() > 0.01:
		body.rotation.y = lerp_angle(body.rotation.y, atan2(-direction.x, -direction.z), delta * ROTATE_LERP)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0.0, DECELERATION * delta)
		velocity.z = move_toward(velocity.z, 0.0, DECELERATION * delta)


func handle_jump() -> void:
	pass