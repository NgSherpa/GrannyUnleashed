extends Node

signal add_scene_at_transform(at_transform: Transform3D, scene: PackedScene)


func emit_add_scene_at_transform(at_transform: Transform3D, scene: PackedScene) -> void:
	add_scene_at_transform.emit(at_transform, scene)
