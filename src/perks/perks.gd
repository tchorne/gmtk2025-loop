extends Node




enum {
	PERK_A,
	PERK_B
}

const NUM_PERKS = 2

var owned_perks: Array[int]
var available_perks: Array[int] = []

func _ready():
	for i in range(NUM_PERKS):
		available_perks.append(i)

func has_perk(perk: int):
	return perk in owned_perks

func get_perk(perk: int):
	if not has_perk(perk):
		owned_perks.append(perk)

func lock_perk(perk: int):
	if perk in available_perks:
		available_perks.erase(perk)

func unlock_perk(perk: int):
	if perk not in available_perks:
		available_perks.append(perk)
		
