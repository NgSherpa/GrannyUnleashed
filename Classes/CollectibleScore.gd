class_name CollectibleScore
extends RefCounted


var _total: int = 0 #points for the coins
var _current: int = 0




func inc() -> void:
	_current += 1

func inc_total() -> void:
	_total += 1

func has_all() -> bool:
	return _current >= _total


func _to_string() -> String:
	return "%02d / %02d" % [_current, _total]
