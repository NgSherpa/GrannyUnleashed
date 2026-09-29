extends Node


const POOL_SIZE : int = 6 #audiostream players ko number

var players: Array[AudioStreamPlayer3D] = []


func add_player() -> AudioStreamPlayer3D:
	var player : AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	add_child(player)
	players.append(player)
	return player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in POOL_SIZE:
		add_player()


func play_3d(stream: AudioStream, pos: Vector3) -> void:
	if stream == null:
		return
	var player: AudioStreamPlayer3D = get_available()
	player.stream = stream
	player.position = pos
	player.play()


func get_available() -> AudioStreamPlayer3D:
	for player in players:
		if not player.playing:
			return player
	return add_player()
