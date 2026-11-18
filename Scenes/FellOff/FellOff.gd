extends Area3D

signal fell_off


func _on_area_entered(area: Area3D) -> void:
	fell_off.emit()
