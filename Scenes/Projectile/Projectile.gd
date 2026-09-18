class_name Projectile
extends Node3D

@export var gravity : float = -1.0
@export var speed : float = 4.0
@export var spin_speed: float = -12.0
var velocity : Vector3 = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity = -global_transform.basis.z * speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	global_position += velocity * delta
	rotate_object_local(Vector3.RIGHT, spin_speed * delta)


func _on_hit_box_hit() -> void:
	queue_free()
