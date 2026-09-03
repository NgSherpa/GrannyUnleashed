class_name Granny

extends CharacterBody3D

const GRAVITY : float = -30
const  ROTATE_LERP : float = 10.0
const SPEED : float = 5.0
const DECELERATION : float = 20.0
const JUMP_VELOCITY: float = 16.0

@onready var land_sound: AudioStreamPlayer = $LandSound
@onready var debug_label: Label3D = $DebugLabel
@onready var body: MeshInstance3D = $Body
@onready var jump_sound: AudioStreamPlayer = $JumpSound


var last_on_floor : bool = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handle_jump()
	handle_movement(delta)
	move_and_slide()
	check_landing()


func handle_movement(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("m_left", "m_right","m_fwd","m_back")
	var direction : Vector3 = Vector3(input_dir.x, 0.0, input_dir.y)
	debug_label.text = "input: (%.1v)\n dir: (%.1v)" % [input_dir, direction]
	
	if direction.length() > 0.01:
		body.rotation.y = lerp_angle(body.rotation.y, atan2(-direction.x, -direction.z), delta * ROTATE_LERP)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0.0, DECELERATION * delta)
		velocity.z = move_toward(velocity.z, 0.0, DECELERATION * delta)

func handle_jump() -> void:
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y += JUMP_VELOCITY
		jump_sound.play()

func apply_gravity(delta: float) -> void:
	velocity.y += GRAVITY * delta

func check_landing() -> void:
	if not last_on_floor and is_on_floor():
		land_sound.play()
	last_on_floor = is_on_floor()
