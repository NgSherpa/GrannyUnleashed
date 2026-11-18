class_name Health
extends Node


signal health_changed(current : int)
signal died

@export var max_health : int = 10

var health : int:
	get:
		return _current_health


var _current_health : int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_current_health = max_health

func take_damage(amount) -> void:
	if amount <=0: return
	set_health(_current_health - amount)


func set_health(value : int) -> void:
	_current_health = clampi(value, 0, max_health)
	print("Health: ", _current_health, " / ", max_health)
	health_changed.emit(_current_health)
	if _current_health == 0:
		print("Out of Health!")
		died.emit()
