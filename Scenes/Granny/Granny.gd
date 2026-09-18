class_name Granny

extends CharacterBody3D

const GRAVITY : float = -30
const FALL_GRAVITY: float = -55.0
const  ROTATE_LERP : float = 10.0
const SPEED : float = 5.0
const DECELERATION : float = 20.0
const JUMP_VELOCITY: float = 16.0
const CAM_ROTATION_SPEED : float = PI
const CAM_TILT_MAX : float = 45.0
const CAM_TILT_HEIGHT : float = 12.0
const CAM_TILT_LERP : float = 4.0

@onready var land_sound: AudioStreamPlayer = $LandSound
@onready var debug_label: Label3D = $DebugLabel
@onready var granny: Node3D = $Granny
@onready var jump_sound: AudioStreamPlayer = $JumpSound
@onready var camera_controller: Node3D = $CameraController
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var walk_sound: AudioStreamPlayer = $WalkSound


var is_moving: bool:
	get: return not Vector2(velocity.x, velocity.z).is_zero_approx()


var is_throwing: bool:
	get:
		return animation_tree.get("parameters/Ground/InvokeThrow/active")

var is_falling: bool:
	get: return velocity.y < 0.0




var last_on_floor : bool = false
var cam_base_tilt: float = 0.0
var ground_y : float = 0.0



func _ready() -> void:
	cam_base_tilt = camera_controller.rotation.x
	ground_y = global_position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handle_jump()
	handle_movement(delta)
	handle_camera(delta)
	handle_throw()
	move_and_slide()
	update_walk_sound()
	check_landing()
	follow_camera()
	update_camera_tilt(delta)

func update_camera_tilt(delta:float) -> void:
	var height: float = maxf(0.0, global_position.y - ground_y)
	var t : float = clampf(height / CAM_TILT_HEIGHT, 0.0, 1.0)
	var target : float = cam_base_tilt - deg_to_rad(CAM_TILT_MAX) * t
	camera_controller.rotation.x = lerp(camera_controller.rotation.x, target, delta * CAM_TILT_LERP)

func follow_camera() -> void:
	camera_controller.global_position = camera_controller.global_position.lerp(global_position, 0.3)

func handle_camera(delta : float) -> void:
	var cam_turn : float = Input.get_axis("cam_left","cam_right")
	debug_label.text += "\n cam: %.2f" % cam_turn
	camera_controller.rotate_y(cam_turn * delta * CAM_ROTATION_SPEED)

func handle_throw() -> void:
	if Input.is_action_just_pressed("shoot") and is_on_floor() and !is_throwing:
		animation_tree.set("parameters/Ground/InvokeThrow/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func update_walk_sound() -> void:
	var walking: bool = is_moving and is_on_floor()
	if !walk_sound.playing  and walking:
		walk_sound.play()
	elif !walking and walk_sound.playing:
			walk_sound.stop()


func handle_movement(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("m_left", "m_right","m_fwd","m_back")
	#var direction : Vector3 = Vector3(input_dir.x, 0.0, input_dir.y)
	var direction : Vector3 = camera_controller.basis * Vector3(input_dir.x, 0.0, input_dir.y)
	debug_label.text = "input: (%.1v)\n dir: (%.1v)" % [input_dir, direction]
	
	if direction.length() > 0.01:
		granny.rotation.y = lerp_angle(granny.rotation.y, atan2(-direction.x, -direction.z), delta * ROTATE_LERP)
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
	velocity.y += (FALL_GRAVITY if velocity.y < 0.0 else GRAVITY) * delta

func check_landing() -> void:
	if not last_on_floor and is_on_floor():
		land_sound.play()
	if is_on_floor():
		ground_y = global_position.y
	last_on_floor = is_on_floor()
