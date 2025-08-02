extends Node
class_name Inventory

signal begin_rental(weapon: String, slot: int)
signal end_rental(slot: int)
signal spendable_money_updated(amount: int)

const RENTAL_TIME = 0.2

@export var all_weapons: Array[Resource]

var total_money := 0
var spendable_money := 0: 
	set(new):
		spendable_money = new
		spendable_money_updated.emit(new)
		
var rentals: Array[Rental]
var unlocked_weapons: Array[String]

var current_rentals: Array[Rental] = []

func update_rentals(time: float) -> void:
	for i in len(current_rentals):
		var rental := current_rentals[i]
		if time > rental.end_time:
			end_rental.emit(1 if get_weapon_by_string(rental.weapon).equipped_slot_1 else 2)
			current_rentals.remove_at(i)
			i -= 1
			break
			
	for rental in rentals:
		if rental in current_rentals: continue
		if time > rental.start_time and rental.end_time > time:
			begin_rental.emit(rental.weapon, 1 if get_weapon_by_string(rental.weapon).equipped_slot_1 else 2)
			var replaced = false
			for i in len(current_rentals):
				var r2 := current_rentals[i]
				if get_weapon_by_string(rental.weapon).equipped_slot_1 == get_weapon_by_string(r2.weapon).equipped_slot_1:
					current_rentals[i] = rental
					replaced = true
			if not replaced:
				current_rentals.append(rental)

func unlock_weapon(weapon: String):
	unlocked_weapons.push_back(weapon)

func get_weapon_by_string(weapon: String) -> WeaponData:
	for w in all_weapons:
		if w.name == weapon:
			return w
	assert(false, "No weapon found " + weapon)
	return null

func debug_rentals():
	rentals = []
	for i in 8:
		var rental = Rental.new()
		var weapon = all_weapons[i] as WeaponData
		weapon.equipped_slot_1 = i%2 == 0
		weapon.equipped_slot_2 = i%2 == 1
		
		rental.weapon = all_weapons[i]
		rental.start_time = i/8.0
		rental.end_time = i/8.0 + 0.25

func create_rental(weapon: WeaponData, start_time: float, stock_price: float) -> Rental:
	var rental = Rental.new()
	rental.weapon = weapon.name
	rental.start_time = start_time
	rental.end_time = start_time + RENTAL_TIME
	
	rentals.append(rental)
	rental.price = int(weapon.base_price * stock_price)
	spendable_money -= rental.price
	
	return rental

func sell_rental(rental: Rental):
	rentals.erase(rental)
	spendable_money += rental.price

func unlock_weapons(money):
	for weapon in all_weapons:
		var wp = weapon as WeaponData
		if wp.unlocked: continue
		if wp.unlock_price <= money:
			wp.unlocked = true

static func get_inventory(node: Node) -> Inventory:
	return node.get_tree().get_first_node_in_group("Inventory") as Inventory

class Rental:
	signal deleted
	var start_time: float
	var end_time: float
	var weapon: String
	var price: int
	
