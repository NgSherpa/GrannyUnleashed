@tool
class_name HitBox
extends Area3D


signal hit

@export var shape : Shape3D:
	set(value):
		shape = value
		apply_shape()


@onready var collision_shape : CollisionShape3D = $CollisionShape3D


func apply_shape() -> void:
	if collision_shape:
		collision_shape.shape = shape

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	apply_shape()





func _on_body_entered(body: Node3D) -> void:
	hit.emit()
