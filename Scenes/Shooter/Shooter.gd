class_name  Shooter
extends Node3D

@export var shoot_stream : AudioStream
@export var db_adjust : float
@export var projectile_scene : PackedScene

@onready var shoot_sound: AudioStreamPlayer3D = $ShootSound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shoot_sound.stream = shoot_stream
	shoot_sound.volume_db = db_adjust


func shoot() -> void:
	shoot_sound.play()
	#var new_projectile : Projectile = projectile_scene.instantiate()
	#add_child(new_projectile)
	#new_projectile.transform = global_transform
	#get_tree().current_scene.add_child(new_projectile)
	SignalHub.emit_add_scene_at_transform(global_transform, projectile_scene)
