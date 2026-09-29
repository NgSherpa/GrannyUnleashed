extends Node3D
@export var explosion_sound: AudioStream 
@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("Run")
	SoundManager.play_3d(explosion_sound, global_position)
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
