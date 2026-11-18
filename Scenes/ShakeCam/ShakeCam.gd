extends Camera3D



@export var shake_time : float = 0.3
@export var shake_amount : float = 0.1



func _ready() -> void:
	set_process(false)
	SignalHub.player_hit.connect(on_player_hit)




func _process(_delta: float) -> void:
	v_offset = randfn(-shake_amount, shake_amount)
	h_offset = randfn(-shake_amount, shake_amount)



func on_player_hit() -> void:
	if is_processing(): return
	set_process(true)
	await get_tree().create_timer(shake_time).timeout
	set_process(false)
	v_offset = 0.0
	h_offset = 0.0
