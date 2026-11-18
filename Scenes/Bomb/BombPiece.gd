class_name BombPiece
extends RigidBody3D

const EXPLOSION_EFFECT = preload("res://Scenes/ExplosionEffect/ExplosionEffect.tscn")
const FALLS_INTO_DEBRIS = preload("uid://cb2c0nfy0556q")


func _on_body_entered(body: Node) -> void:
	SoundManager.play_3d(FALLS_INTO_DEBRIS, global_position)
	SignalHub.emit_add_scene_at_transform(global_transform, EXPLOSION_EFFECT)
	queue_free()
