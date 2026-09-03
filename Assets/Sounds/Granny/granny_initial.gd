class_name Granny
extends CharacterBody3D


const GRAVITY: float = -30.0


@onready var land_sound: AudioStreamPlayer = $LandSound


var _last_on_floor: bool = false


func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	move_and_slide()


func apply_gravity(delta: float) -> void:
	pass


func check_landing() -> void:
	pass





