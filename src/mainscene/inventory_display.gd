extends Control

@onready var inventory = Inventory.get_inventory(self)

func _on_inventory_begin_rental(weapon: String, slot: int) -> void:
	var data: WeaponData = inventory.get_weapon_by_string(weapon)
	
	[$Slot1/Weapon, $Slot2/Weapon][slot-1].texture = data.image
	


func _on_inventory_end_rental(slot: int) -> void:
	[$Slot1/Weapon, $Slot2/Weapon][slot-1].texture = null
