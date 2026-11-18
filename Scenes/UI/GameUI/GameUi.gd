extends Control


@onready var ui_collected_coins: UICollected = $PC/HBPickUps/UICollectedCoins
@onready var ui_collected_jewels: UICollected = $PC/HBPickUps/UICollectedJewels
@onready var ui_collected_score: UICollected = $PC/HBPickUps/UICollectedScore

@onready var key: TextureRect = $PC/Key
@onready var hb_hearts: HBoxContainer = $PC/HBHearts
@onready var game_over_rect: ColorRect = $GameOverRect
@onready var game_over_label: Label = $GameOverRect/GameOverLabel
@onready var level_complete_rect: ColorRect = $LevelCompleteRect
@onready var level_complete_label: Label = $LevelCompleteRect/LevelCompleteLabel

var _hearts : Array[TextureRect] = []
var _did_complete : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in hb_hearts.get_children():
		if child is TextureRect: _hearts.append(child)
	SignalHub.update_ui.connect(on_update_ui)
	SignalHub.show_key.connect(on_show_key)
	SignalHub.level_completed.connect(on_level_completed)
	SignalHub.score_changed.connect(on_score_changed)
	SignalHub.player_health_changed.connect(on_player_health_changed)
	ScoreManager.start_level()

func on_player_health_changed(current : int) -> void:
	for i in _hearts.size():
		_hearts[i].visible = current > i
	if current <= 0:
		_did_complete = false
		level_ended()


func level_ended() -> void:
	if _did_complete:
		level_complete_label.text = "LEVEL COMPLETE!" 
		level_complete_rect.show()
	else:
		game_over_label.text = "GAME OVER :("
		game_over_rect.show()
	get_tree().paused = true

func on_score_changed(total : int) -> void:
	ui_collected_score.set_amount(str(total))

func on_level_completed() -> void:
	_did_complete = true
	level_ended()



func on_show_key() -> void:
	key.show()

func on_update_ui(scores : Dictionary[GameDefs.PickUpType, CollectibleScore]) -> void:
	ui_collected_coins.set_amount(str(scores[GameDefs.PickUpType.Coin]))
	ui_collected_jewels.set_amount(str(scores[GameDefs.PickUpType.Jewel]))
