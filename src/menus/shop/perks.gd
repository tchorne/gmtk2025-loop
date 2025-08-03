extends TextureRect

const PerkButton = preload("res://src/menus/shop/perk_button.gd")

func get_perks() -> Array[PerkButton]:
	return [
		$Control/VBoxContainer/TextureRect,
		$Control/VBoxContainer2/TextureRect2,
		$Control/VBoxContainer3/TextureRect3,
		$Control/VBoxContainer/Secret2/TextureRect3,
		$Control/VBoxContainer2/Secret/TextureRect3
	]
