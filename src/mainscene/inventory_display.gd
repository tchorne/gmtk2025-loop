extends Control

@onready var inventory = Inventory.get_inventory(self)

func _on_inventory_begin_rental(weapon: String, slot: int) -> void:
	var data: WeaponData = inventory.get_weapon_by_string(weapon)
	var s = [$Slot1/Weapon, $Slot2/Weapon][slot-1]
	s.texture = data.image
	s.scale = Vector2.ONE * 1.5
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(s, "scale", Vector2.ONE, 0.2)


func _on_inventory_end_rental(slot: int) -> void:
	[$Slot1/Weapon, $Slot2/Weapon][slot-1].texture = null
