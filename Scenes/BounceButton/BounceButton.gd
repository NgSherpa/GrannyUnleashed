extends Area3D


@export var bounce_speed : float = 10.0
@onready var sound: AudioStreamPlayer3D = $Sound

func _on_body_entered(body: Node3D) -> void:
	if body is Granny:
		sound.play()
		body.start_bounce(bounce_speed)
