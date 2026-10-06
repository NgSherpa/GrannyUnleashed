extends Node

var _scores: Dictionary[GameDefs.PickUpType, CollectibleScore] = {}
var _points : int = 0





func start_level() -> void:
	count_pickups()
	SignalHub.emit_update_ui(_scores)
	SignalHub.emit_score_changed(_points)
func count_pickups() -> void:
	for type in GameDefs.PickUpType.values():
		_scores[type] = CollectibleScore.new()
	for pu in get_tree().get_nodes_in_group(GameDefs.GROUP_PICKUP):
		if pu is not PickUp : continue
		_scores[pu.pickup_type].inc_total()
	pass

func _ready() -> void:
	SignalHub.collected.connect(on_collected)
	SignalHub.points.connect(on_points)


func on_points(amount: int, _at : Vector3)-> void:
	_points += amount
	SignalHub.emit_score_changed(_points)


func on_collected(type: GameDefs.PickUpType) -> void:
	if not _scores.has(type) : return
	_scores[type].inc()
	if type == GameDefs.PickUpType.Jewel and _scores[type].has_all():
		SignalHub.emit_show_key()
	SignalHub.emit_update_ui(_scores)
