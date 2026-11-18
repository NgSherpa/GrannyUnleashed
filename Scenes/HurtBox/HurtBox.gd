@tool
class_name HurtBox
extends Area3D


signal hurt

@export var shape : Shape3D:
	set(value):
		shape = value
		apply_shape()

@export var health : Health


@onready var collision_shape : CollisionShape3D = $CollisionShape3D


func apply_shape() -> void:
	if collision_shape:
		collision_shape.shape = shape

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	apply_shape()



func _on_area_entered(area: Area3D) -> void:
	if area is HitBox:
		hurt.emit()
		if health:
			health.take_damage(area.damage)
