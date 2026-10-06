class_name PickUp

extends Area3D

@export var collection_sound : AudioStream
@export var points : int
@export var pickup_type : GameDefs.PickUpType = GameDefs.PickUpType.None

func _enter_tree() -> void:
	add_to_group(GameDefs.GROUP_PICKUP)

func _ready() -> void:
	if pickup_type == GameDefs.PickUpType.LevelKey:
		monitoring = false   #monitoring = the area 3d (this one) is able to detect collisions from other collison shapes when things walk into it. 'monitors' the other collison shapes when they walk into it
		hide()
		SignalHub.show_key.connect(reveal)



func reveal() -> void:
	show()
	set_monitoring.call_deferred(true) # called in idle time so the physics process is not interfered with


func _on_body_entered(body: Node3D) -> void:
	if body is Granny:
		if collection_sound:
			SoundManager.play_3d(collection_sound, global_position)
			
		SignalHub.emit_collected(pickup_type)
		SignalHub.emit_points(points, global_position)
		queue_free()
