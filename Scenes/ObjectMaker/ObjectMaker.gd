extends Node3D




@export var score_effect_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalHub.add_scene_at_transform.connect(on_add_scene_transform)
	SignalHub.points.connect(on_points)


func spawn_score_effect(amount: int, at: Vector3)-> void:
	var nse: Label3D = score_effect_scene.instantiate()
	nse.position = at
	nse.text = "+%d" % amount
	add_child(nse)

func on_points(amount: int, at : Vector3)-> void:
	if score_effect_scene:
		spawn_score_effect.call_deferred(amount, at)

func on_add_scene_transform(at_transform: Transform3D, scene: PackedScene) -> void:
	var ns: Node3D = scene.instantiate()
	ns. transform = at_transform
	add_child.call_deferred(ns) #helps call it outside the physics process calculations so we dont have much trouble with it during execution
