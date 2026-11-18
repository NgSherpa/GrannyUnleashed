class_name TrackPlayer
extends Node3D


signal spotted
signal lost

@export_range(-50.0, -2.0) var sight_range: float = -20.0
@export var max_up : float = 10.0
@export var max_down: float = 10.0

@onready var ray_cast: RayCast3D = $RayCast


var player : Granny
var can_see : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group(GameDefs.GROUP_GRANNY) as Granny
	if !player:
		get_parent().queue_free()
	ray_cast.target_position.z = sight_range


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	ray_cast.look_at(player.global_position)
	ray_cast.rotation.x = clampf(ray_cast.rotation.x, -deg_to_rad(max_up), deg_to_rad(max_down))
	update_sight()


func flat_position(base_y : float) -> Vector3:
	return Vector3(player.global_position.x, base_y, player.global_position.z)


func update_sight() -> void:
	var seen: bool = ray_cast.is_colliding() and ray_cast.get_collider() is Granny
	if seen!= can_see:
		can_see = seen
		if seen:
			print("Seen the Player")
			spotted.emit()
		else:
			print("Lost the Player")
			lost.emit()
