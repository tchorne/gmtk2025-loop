extends Node
class_name Inventory

@export var all_weapons: Array[WeaponData]

var rentals: Array[Rental]
var unlocked_weapons: Array[String]


func unlock_weapon(weapon: String):
	unlocked_weapons.push_back(weapon)

static func get_inventory(node: Node) -> Inventory:
	return node.get_tree().get_first_node_in_group("Inventory") as Inventory


class Rental:
	var start_time: float
	var end_time: float
	var weapon: String
