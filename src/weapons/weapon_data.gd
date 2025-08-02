extends Resource
class_name WeaponData

var weapon_index := -1

@export var base_price: float
@export var unlock_price: float
@export var name: String
@export var display_name: String = ""
@export_multiline var description: String
@export var equipped_slot_1: bool
@export var equipped_slot_2: bool
@export var unlocked: bool = false
@export var unknown: bool = false
@export var image: CompressedTexture2D

func get_display_name():
	if display_name == "": return name
	return display_name

func get_image() -> Image:
	return image.get_image()
