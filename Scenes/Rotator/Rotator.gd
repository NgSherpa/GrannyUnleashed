#grabs hold of its parent and makes its parent rotate
extends Node

@export var spin_axis : Vector3 = Vector3.RIGHT
@export var spin_speed : float = 1.0
@export var randomize_spin : bool = false

@onready var _target : Node3D = get_parent() as Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randomize_spin:
		spin_axis = Vector3(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
	if spin_axis.is_zero_approx():
		spin_speed = 0
		spin_axis = Vector3.UP
	spin_axis = spin_axis.normalized()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _target:
		_target.rotate_object_local(spin_axis, spin_speed * delta)
