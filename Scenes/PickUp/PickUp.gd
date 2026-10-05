extends Area3D

@export var collection_sound : AudioStream
@export var points : int



func _on_body_entered(body: Node3D) -> void:
	if body is Granny:
		if collection_sound:
			SoundManager.play_3d(collection_sound, global_position)
		queue_free()
