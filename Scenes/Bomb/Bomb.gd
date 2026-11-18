extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var explode_point: Marker3D = $ExplodePoint
const _321215__HYBRID_V__SCI_FI_WEAPONS_DEPLOY = preload("res://Assets/Sounds/Bomb/321215__hybrid_v__sci-fi-weapons-deploy.wav")

@export var explode_scene : PackedScene



func _on_detect_body_entered(_body: Node3D) -> void:
	animation_player.play("CountDown")
	SoundManager.play_3d(_321215__HYBRID_V__SCI_FI_WEAPONS_DEPLOY, global_position)


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if explode_scene:
		SignalHub.emit_add_scene_at_transform(explode_point.global_transform, explode_scene)
	queue_free()
