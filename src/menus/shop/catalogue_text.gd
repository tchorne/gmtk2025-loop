extends Control

@onready var name_label: Label = $Name
@onready var price: Label = $Price
@onready var slot_1: TextureButton = $Slot1
@onready var slot_2: TextureButton = $Slot2

var data: WeaponData

func set_weapon(weapon: WeaponData):
	data = weapon
	
	slot_1.set_pressed_no_signal(weapon.equipped_slot_1)
	slot_1.get_node("TextureRect").visible = weapon.equipped_slot_1
	slot_2.set_pressed_no_signal(weapon.equipped_slot_2)
	slot_2.get_node("TextureRect").visible = weapon.equipped_slot_2
	if not weapon.unlocked:
		name_label.text = "???"
		
		price.text = "Gain at least $" + str(weapon.unlock_price) + " to unlock"
		slot_1.visible = false
		slot_2.visible = false
	else:
		name_label.text = weapon.get_display_name()
		slot_1.visible = true
		slot_2.visible = true


func _on_texture_button_pressed() -> void:
	var b = data.equipped_slot_1
	if b:
		data.equipped_slot_1 = false
		data.equipped_slot_2 = true
	else:
		data.equipped_slot_1 = true
		data.equipped_slot_2 = false
		
	slot_1.set_pressed_no_signal(data.equipped_slot_1)
	slot_1.get_node("TextureRect").visible = data.equipped_slot_1
	slot_2.set_pressed_no_signal(data.equipped_slot_2)
	slot_2.get_node("TextureRect").visible = data.equipped_slot_2
	
