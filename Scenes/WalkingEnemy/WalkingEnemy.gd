class_name WalkingEnemy
extends CharacterBody3D

@export var gravity : float = -9.0
@export var speed : float = 3.0
@onready var walk_sound: AudioStreamPlayer3D = $WalkSound
@onready var angry_sound: AudioStreamPlayer3D = $AngrySound
@onready var track_player: TrackPlayer = $TrackPlayer
@onready var death_explosion: DeathExplosion = $DeathExplosion


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _update() -> void:
	pass


func face_player() -> void:
	#var target : Vector3 = track_player.player.global_position
	var target : Vector3 = track_player.flat_position(global_position.y)
	if global_position.distance_to(target) > 0.1:
		look_at(target)


func move_towards_player() -> void:
	face_player()
	move_forward()

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	move_and_slide()
	_update()


func move_forward() -> void:
	var dir : Vector3 = -transform.basis.z
	velocity.x = dir.x * speed
	velocity.z = dir.z * speed
	

func _on_hurt_box_hurt() -> void:
	death_explosion.die()


func _on_track_player_spotted() -> void:
	pass


func _on_track_player_lost() -> void:
	pass


func _on_fell_off() -> void:
	queue_free()
