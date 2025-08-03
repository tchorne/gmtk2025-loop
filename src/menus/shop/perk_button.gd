extends TextureRect

signal hovered_or_updated(control: Control, perk: int)

var my_perk := -1

static var perk_price : int :
	get:
		return 25 * pow(2, Perks.owned_perks.size())

var money_spent = 0

var sold := false

func _ready():
	randomize()
	GameState.get_state(self).reload_perks.connect(load_random_perk)

func load_random_perk():
	my_perk = -1
	money_spent = 0
	sold = false
	var unowned_perks = range(Perks.NUM_PERKS).filter(func(x): return not Perks.has_perk(x))
	if unowned_perks.is_empty():
		visible = false
		return
	visible = true
	my_perk = unowned_perks.pick_random()
	$Label.text = str(my_perk+1)

func _on_gui_input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton): return
	if not event.is_released(): return
	var inventory := Inventory.get_inventory(self)
	if not sold and event.button_index == MOUSE_BUTTON_LEFT:
		if my_perk > 0 and inventory.spendable_money >= perk_price:
			inventory.spendable_money -= perk_price
			money_spent = perk_price
			Perks.get_perk(my_perk)
			sold = true
			hovered_or_updated.emit(self, my_perk)
	elif sold and event.button_index == MOUSE_BUTTON_RIGHT:
		Perks.remove_perk(my_perk)
		inventory.spendable_money += money_spent
		money_spent = 0
		sold = false
		hovered_or_updated.emit(self, my_perk)


func _on_mouse_entered() -> void:
	
	hovered_or_updated.emit(self, my_perk)
