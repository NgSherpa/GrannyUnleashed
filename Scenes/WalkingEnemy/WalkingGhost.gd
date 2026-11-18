extends WalkingEnemy

var _on_screen : bool = false
const DISTANCE : float = 7.0


func _update() -> void:
	if track_player.can_see:
		face_player()
		
	var advancing : bool = should_advance()
	if advancing:
		move_forward()
	else:
		velocity.x = 0
		velocity.z = 0
	
	
	if advancing and not walk_sound.playing:
		walk_sound.play()
	elif not advancing:
		walk_sound.stop()


func should_advance() -> bool:
	if not track_player.can_see:
		return false
	if global_position.distance_to(track_player.player.global_position) <= DISTANCE:
		return true
	return not _on_screen


func _on_track_player_spotted() -> void:
	angry_sound.play()


func _on_visible_on_screen_screen_entered() -> void:
	print("Screen Entered")
	_on_screen = true


func _on_visible_on_screen_screen_exited() -> void:
	print("Screen Exited")
	_on_screen = false
