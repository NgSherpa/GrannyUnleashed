
class_name UICollected
extends HBoxContainer

@export var item_image : Texture2D


@onready var image: TextureRect = $Image
@onready var label_amount: Label = $LabelAmount


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	image.texture = item_image


func set_amount(txt : String) -> void:
	label_amount.text = txt
