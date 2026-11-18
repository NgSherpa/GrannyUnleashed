extends Node3D
@onready var track_player: TrackPlayer = $TrackPlayer
@onready var pivot: Node3D = $Pivot
@onready var shooter: Shooter = $Pivot/Shooter
@onready var death_explosion: DeathExplosion = $DeathExplosion


func _on_timer_timeout() -> void:
	if track_player.can_see:
		shooter.look_at(track_player.player.global_position)
		shooter.shoot()

func _physics_process(_delta: float) -> void:
	if track_player.can_see:
		pivot.look_at(track_player.player.global_position)


func _on_health_died() -> void:
	death_explosion.die()
