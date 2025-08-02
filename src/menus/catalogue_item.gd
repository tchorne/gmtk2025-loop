extends Control

signal weapon_equipped(item: Control, weapon: WeaponData, slot: int)

const CatalogueText = preload("res://src/menus/shop/catalogue_text.gd")

@onready var catalogue_text : CatalogueText = get_child(0)
@onready var texture = get_child(1).get_child(0)


func _ready():
	catalogue_text.slot_1.toggled.connect(equip_updated.bind(1))
	catalogue_text.slot_2.toggled.connect(equip_updated.bind(2))

func load_weapon(data: WeaponData):
	catalogue_text.set_weapon(data)
	$Item.get_child(0).modulate = Color.WHITE if data.unlocked else Color.BLACK
	
func equip_updated(toggle: bool, slot: int):
	if toggle:
		weapon_equipped.emit(self, catalogue_text.data, slot)

func unequip():
	catalogue_text.slot_1.button_pressed = false
	catalogue_text.slot_2.button_pressed = false
