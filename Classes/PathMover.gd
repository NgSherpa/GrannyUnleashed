@tool

extends PathFollow3D


@export var speed : float = 1.5
@export var ping_pong : bool = true


var _direction : int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if ping_pong: loop = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	progress += delta * speed * _direction
	
	if !ping_pong : return
	
	if progress_ratio > 0.99 and _direction == 1:
		_direction = -1
	if progress_ratio < 0.01 and _direction == -1:
		_direction = 1
	
	
