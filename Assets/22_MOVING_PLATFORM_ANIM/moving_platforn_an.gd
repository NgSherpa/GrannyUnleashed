@tool
extends Node3D


@export var offset: Vector3 = Vector3(0, 10, 0):
	set(value):
		offset = value
		start_tween()

@export var duration: float = 2.0:
	set(value):
		duration = value
		start_tween()


@onready var animatable_body_3d: AnimatableBody3D = $AnimatableBody3D


var _tween: Tween


func _ready() -> void:
	start_tween()


func start_tween() -> void:
	if Engine.is_editor_hint():
		if !is_node_ready(): return
	if _tween: _tween.kill()
	_tween = create_tween()
	_tween.set_loops()
	_tween.tween_property(animatable_body_3d, "position", offset, duration)
	_tween.tween_property(animatable_body_3d, "position", Vector3.ZERO, duration)
