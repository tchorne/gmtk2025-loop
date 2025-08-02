extends Control

@onready var name_label: Label = $Name
@onready var price: Label = $Price
@onready var slot_1: TextureButton = $Slot1
@onready var slot_2: TextureButton = $Slot2

var data: WeaponData

func set_weapon(weapon: WeaponData):
	data = weapon
	if not weapon.unlocked:
		name_label.text = "???"
		
		price.text = "Gain at least $" + str(weapon.unlock_price) + " to unlock"
		slot_1.visible = false
		slot_2.visible = false
	else:
		name_label.text = weapon.get_display_name()
		slot_1.visible = true
		slot_2.visible = true
