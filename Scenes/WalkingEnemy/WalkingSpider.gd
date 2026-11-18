extends WalkingEnemy

@onready var floor_detect: RayCast3D = $FloorDetect



func _update() -> void:
	if track_player.can_see:
		move_towards_player()
	else:
		patrol()



func patrol() -> void:
	if is_on_wall() or not floor_detect.is_colliding():
		rotate_y(deg_to_rad(randf_range(150.0, 210.0)))
	move_forward()
	

func _on_track_player_spotted() -> void:
	walk_sound.stop()
	angry_sound.play()


func _on_track_player_lost() -> void:
	angry_sound.stop()
	walk_sound.play()
