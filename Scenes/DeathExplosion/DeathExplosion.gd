class_name DeathExplosion
extends Node3D


@export var explosion_scene : PackedScene
@export var killing_points : int = 0


func die() -> void:
	if explosion_scene:
		SignalHub.emit_add_scene_at_transform(global_transform, explosion_scene)
	SignalHub.emit_points(killing_points, global_position)
	get_parent().queue_free()
