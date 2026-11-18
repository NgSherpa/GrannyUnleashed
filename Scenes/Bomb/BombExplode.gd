extends Node3D


@export var sound : AudioStream

const BOMB_PIECE = preload("res://Scenes/Bomb/BombPiece.tscn")
const  PIECE_COUNT : int = 20
const SPREAD: float = 1.0
const LIFT_MIN: float = 3.0
const LIFT_MAX: float = 5.0
const IMPULSE_MIN: float = 3.0
const IMPULSE_MAX: float = 15.0

@onready var hit_box: HitBox = $HitBox


func _ready() -> void:
	if sound:
		SoundManager.play_3d(sound, global_position)
	spawn_pieces()
	blast()


func blast() -> void:
	await get_tree().physics_frame
	await get_tree().physics_frame
	hit_box.set_monitorable.call_deferred(false)


func spawn_pieces() -> void:
	for i in PIECE_COUNT:
		var piece: BombPiece = BOMB_PIECE.instantiate()
		add_child(piece)
		var dir: Vector3 = Vector3(
			randf_range(-SPREAD, SPREAD),
			randf_range(LIFT_MIN, LIFT_MAX),
			randf_range(-SPREAD, SPREAD)
		).normalized()
		piece.apply_central_impulse(dir * randf_range(IMPULSE_MIN, IMPULSE_MAX))
