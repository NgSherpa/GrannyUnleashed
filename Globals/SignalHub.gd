extends Node

signal add_scene_at_transform(at_transform: Transform3D, scene: PackedScene)

signal collected(type: GameDefs.PickUpType)

signal update_ui(scores : Dictionary[GameDefs.PickUpType, CollectibleScore])

signal show_key

signal level_completed

signal points(amount: int, at: Vector3) #vector 3 to know where to add the floating score labels later (score effect scene)

signal score_changed(total: int)


func emit_score_changed(total: int) -> void:
	score_changed.emit(total)

func emit_points(amount : int, at : Vector3) -> void:
	points.emit(amount, at)

func emit_level_completed() -> void:
	level_completed.emit()

func emit_show_key() -> void:
	show_key.emit()


func emit_update_ui(scores: Dictionary[GameDefs.PickUpType, CollectibleScore]) -> void:
	update_ui.emit(scores)


func emit_collected(type : GameDefs.PickUpType) -> void:
	collected.emit(type)



func emit_add_scene_at_transform(at_transform: Transform3D, scene: PackedScene) -> void:
	add_scene_at_transform.emit(at_transform, scene)
