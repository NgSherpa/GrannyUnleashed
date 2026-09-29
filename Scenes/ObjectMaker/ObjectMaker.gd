extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalHub.add_scene_at_transform.connect(on_add_scene_transform)


func on_add_scene_transform(at_transform: Transform3D, scene: PackedScene) -> void:
	var ns: Node3D = scene.instantiate()
	ns. transform = at_transform
	add_child.call_deferred(ns) #helps call it outside the physics process calculations so we dont have much trouble with it during execution
