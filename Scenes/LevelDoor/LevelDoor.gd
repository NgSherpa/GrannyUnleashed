extends Node3D

@onready var no_exit_sound: AudioStreamPlayer = $NoExitSound
@onready var key_label: Label3D = $KeyLabel

var _can_enter : bool = false
var _completed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalHub.collected.connect(on_collected)


func show_need_key() -> void:
	if key_label.visible : return
	no_exit_sound.play()
	key_label.show()
	await get_tree().create_timer(2.0, false).timeout
	key_label.hide()

func on_collected(type : GameDefs.PickUpType) -> void:
	if type == GameDefs.PickUpType.LevelKey:
		_can_enter = true


func _on_player_detect_body_entered(body: Node3D) -> void:
	if body is not Granny : return
	if _completed : return
	if not _can_enter:
		show_need_key()
		return
	_completed = true
	SignalHub.emit_level_completed()
