class_name Granny
extends CharacterBody3D


const GRAVITY: float = -30.0


@onready var land_sound: AudioStreamPlayer = $LandSound


var _last_on_floor: bool = false


func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	move_and_slide()
	check_landing()


func apply_gravity(delta: float) -> void:
	velocity.y += GRAVITY * delta


func check_landing() -> void:
	if not _last_on_floor and is_on_floor():
		land_sound.play()
	_last_on_floor = is_on_floor()






