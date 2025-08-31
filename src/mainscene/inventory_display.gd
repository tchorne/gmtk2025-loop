extends Control

const INVENTORY_DISPLAY_WEAPON = preload("res://src/schedule/inventory_display_weapon.tscn")

@onready var inventory = Inventory.get_inventory(self)
@export var player: Node

var weapon_displays : Array[RentalDisplay] = [] # Queue

var slot_1: RentalDisplay
var slot_2: RentalDisplay

func _on_inventory_init_rentals(weapons: Array[String]):
	for display in weapon_displays:
		display.texture_rect.queue_free()
		display.free()
		
	var slot = 3
	for weapon_name in weapons:
		var weapon = inventory.get_weapon_by_string(weapon_name)
		var rental_display = RentalDisplay.new()
		rental_display.texture_rect = INVENTORY_DISPLAY_WEAPON.instantiate()
		add_child(rental_display.texture_rect)
		rental_display.set_slot(slot, self)
		rental_display.texture_rect.texture = weapon.image
		weapon_displays.append(rental_display)
		slot += 1
		
func _on_inventory_begin_rental(weapon: String) -> void:
	var data: WeaponData = inventory.get_weapon_by_string(weapon)
	
	if slot_1 == null:
		slot_1 = weapon_displays.pop_front()
		slot_1.update_slot(1, self)
	elif slot_2 == null:
		slot_2 = weapon_displays.pop_front()
		slot_2.update_slot(2, self)
	else:
		slot_1.discard()
		slot_1 = slot_2
		slot_1.update_slot(1, self)
		slot_2 = weapon_displays.pop_front()
		if slot_2:
			slot_2.update_slot(2, self)
	
	for display in weapon_displays:
		assert(display.slot != 3)
		display.update_slot(display.slot - 1, self)


func _on_inventory_end_rental(slot: int) -> void:
	if slot == 1:
		slot_1.discard()
		slot_1 = null
		if slot_2 != null:
			slot_1 = slot_2
			slot_2 = null
			slot_1.update_slot(1, self)

func _on_game_state_begin_day() -> void:
	var weapons: Array[String]
	for rental in inventory.get_rentals_by_time():
		weapons.append(rental.weapon)
		
	_on_inventory_init_rentals(weapons)
	
class RentalDisplay:
	var texture_rect: TextureRect
	var slot: int
	

	func get_slot_position(s: int, inventory):
		if s == 1:
			return inventory.get_node("Weapon").position
		if s == 2:
			return inventory.get_node("Weapon2").position
		return Vector2(100 * s - 175, -20)
		
	func get_slot_opacity(s: int):
		if s <= 0: 
			return 0
		elif s <= 2:
			return 1
		else:
			return max(1-0.4-(0.2*(s-3)), 0)
		
	func set_slot(s: int, inventory):
		texture_rect.position = get_slot_position(s, inventory)
		texture_rect.self_modulate.a = get_slot_opacity(s)
		slot = s
	
	func update_slot(s: int, inventory):
		var tween = texture_rect.create_tween().bind_node(texture_rect).set_parallel(true)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(texture_rect, "position", get_slot_position(s, inventory), 0.2)
		tween.tween_property(texture_rect, "self_modulate:a", get_slot_opacity(s), 0.2)
		slot = s
	
	func discard():
		var tween = texture_rect.create_tween().bind_node(texture_rect).set_parallel(true)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(texture_rect, "position", texture_rect.position + Vector2.DOWN*100, 0.2)
		tween.tween_property(texture_rect, "self_modulate:a", 0, 0.3)
