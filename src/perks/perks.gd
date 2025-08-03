extends Node


signal perk_acquired(perk: int)

enum {
	TITANIUM_CHAIR,
	RESUPPLY,
	OZONE,
	IMPROVED_NOZZLE,
	HOTTER_GAS,
	BARBED_HOOKS,
	HEAVY_BULLETS,
	GRAVITRONS,
	ON_DEMAND,
	STATUS_DURATION,
	RECOVERY_SPEED,
	MOVEMENT_SPEED,
	STRENGTH,
	MORE_OPTIONS,
	DOUBLE_JUMP,
	AIR_CONTROL,
	GOLD_BULLETS,
	PURPLE,
}

const PERK_DESCRIPTIONS = {
	TITANIUM_CHAIR: "Chair does 50% more structural damage", #
	RESUPPLY: "Office Supplies thrown 20% faster", #
	OZONE: "Tomorrow's Fan deals 100% more damage", #
	IMPROVED_NOZZLE: "Flamethrower has a longer range", 
	HOTTER_GAS: "Flamethrower does 30% more damage", #
	BARBED_HOOKS: "ElectroHook lasts 50% longer", #
	HEAVY_BULLETS: "Minigun does 30% more damage", #
	GRAVITRONS: "Shield inflicts anti-gravity instantly", #
	ON_DEMAND: "Laser strikes 50% faster", #
	STATUS_DURATION: "Statuses last 20% longer", #
	RECOVERY_SPEED: "Recover 50% faster after being hit", #
	MOVEMENT_SPEED: "Increased Movement Speed", #
	STRENGTH: "All damage +5%", #
	MORE_OPTIONS: "Future perk choices have more options",
	DOUBLE_JUMP: "Allows double jumping", #
	AIR_CONTROL: "Better movement control mid-air", #
	GOLD_BULLETS: "Bullets have a chance to become generate money on hit", #
	PURPLE: "Become Purple" #
}

const PERK_NAMES = {
	TITANIUM_CHAIR: "Titanium Chair",
	RESUPPLY: "Resupply",
	OZONE: "Ozone",
	IMPROVED_NOZZLE: "Improved Nozzle",
	HOTTER_GAS: "Hotter Gas",
	BARBED_HOOKS: "Barbed Hooks",
	HEAVY_BULLETS: "Heavy Bullets",
	GRAVITRONS: "Gravitrons",
	ON_DEMAND: "On Demand",
	STATUS_DURATION: "Status Duration",
	RECOVERY_SPEED: "Recovery Speed",
	MOVEMENT_SPEED: "Movement Speed",
	STRENGTH: "Strength",
	MORE_OPTIONS: "More Options",
	DOUBLE_JUMP: "Double Jump",
	AIR_CONTROL: "Air Control",
	GOLD_BULLETS: "Gold Bullets",
	PURPLE: "Purple",
}

const NUM_PERKS = 18

var owned_perks: Array[int] = []
var available_perks: Array[int] = []

func _ready():
	for i in range(NUM_PERKS):
		available_perks.append(i)

func has_perk(perk: int):
	return perk in owned_perks

func remove_perk(perk: int):
	owned_perks.erase(perk)

func get_perk(perk: int):
	if not has_perk(perk):
		owned_perks.append(perk)
		perk_acquired.emit(perk)

func lock_perk(perk: int):
	if perk in available_perks:
		available_perks.erase(perk)

func unlock_perk(perk: int):
	if perk not in available_perks:
		available_perks.append(perk)
		
