extends Control

@onready var name_label: Label = $Name
@onready var price: Label = $Price
@onready var slot_1: TextureButton = $Slot1
@onready var slot_2: TextureButton = $Slot2

func set_weapon(weapon: WeaponData):
	if weapon.unknown:
		name_label.text = "Locked"
		price.text = weapon.unc
