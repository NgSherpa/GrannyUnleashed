extends Control


@onready var ui_collected_coins: UICollected = $PC/HBPickUps/UICollectedCoins
@onready var ui_collected_jewels: UICollected = $PC/HBPickUps/UICollectedJewels
@onready var ui_collected_score: UICollected = $PC/HBPickUps/UICollectedScore

@onready var key: TextureRect = $PC/Key

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalHub.update_ui.connect(on_update_ui)
	SignalHub.show_key.connect(on_show_key)
	SignalHub.level_completed.connect(on_level_completed)
	SignalHub.score_changed.connect(on_score_changed)
	ScoreManager.start_level()


func on_score_changed(total : int) -> void:
	ui_collected_score.set_amount(str(total))

func on_level_completed() -> void:
	get_tree().paused = true


func on_show_key() -> void:
	key.show()

func on_update_ui(scores : Dictionary[GameDefs.PickUpType, CollectibleScore]) -> void:
	ui_collected_coins.set_amount(str(scores[GameDefs.PickUpType.Coin]))
	ui_collected_jewels.set_amount(str(scores[GameDefs.PickUpType.Jewel]))
