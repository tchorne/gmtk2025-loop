extends Control

const WEAPON_STOCK = preload("res://src/menus/shop/weapon_stock.tscn")
const WeaponStock = preload("res://src/menus/shop/weapon_stock.gd")
const Description = preload("res://src/menus/description.gd")
const OFF_SCREEN_MIDDLE = Vector2(413, 704)
const BOTTOM_SCREEN_MIDDLE = Vector2(397, 480)

@onready var description: Description = $Description

@onready var inventory := Inventory.get_inventory(self)
@onready var catalogue: TextureRect = $Catalogue
@onready var rentals: TextureRect = $Rentals
@onready var weapon_stocks: VBoxContainer = %WeaponStocks

func _ready():
	inventory.spendable_money_updated.connect(on_spendable_updated)
	
	for i in 8:
		var weapon := inventory.all_weapons[i] as WeaponData
		inventory.all_weapons[i].weapon_index = i
		var child = catalogue.get_node(str(i+1))
		child.load_weapon(inventory.all_weapons[i])
		child.weapon_equipped.connect(on_weapon_equipped)
		child.mouse_entered.connect(on_catalogue_weapon_hovered.bind(child, weapon))
		
		var stock : WeaponStock = WEAPON_STOCK.instantiate()
		weapon_stocks.add_child(stock)
		stock.load_weapon(weapon)
		stock.price_hovered.connect(on_stock_price_hovered.bind(weapon, stock))
		stock.price_clicked.connect(on_stock_price_clicked.bind(weapon, stock))
		stock.rental_hovered.connect(on_rental_hovered.bind(weapon))
		stock.rental_sold.connect(on_rental_sold)
	
	for tab in get_tree().get_nodes_in_group("MenuTab"):
		tab.selected.connect(on_tab_selected)
	
	for perk in $Perks.get_perks():
		perk.hovered_or_updated.connect(on_perk_hover)
		
		
func setup(): ## Called at the end of each day
	inventory.spendable_money = inventory.total_money
	$Money/Backdrop/total.text = "$" + str(inventory.total_money)
	var i = 0
	for stock in weapon_stocks.get_children():
		stock.generate_history()
		stock.load_weapon(inventory.all_weapons[i])
		i += 1
	
	for j in 8:
		var weapon := inventory.all_weapons[j] as WeaponData
		inventory.all_weapons[j].weapon_index = j
		var child = catalogue.get_node(str(j+1))
		child.load_weapon(inventory.all_weapons[j])
		
	$"../Info/Quota".text = "$" + str(int(GameState.get_state(self).get_quota(true)))
	
func on_weapon_equipped(item: Control, weapon: WeaponData, slot: int):
	pass
	#if slot == 1:
		#weapon.equipped_slot_1 = true
		#weapon.equipped_slot_2 = false
		#item.catalogue_text.slot_2.set_pressed_no_signal(false)
	#else:
		#weapon.equipped_slot_1 = false
		#weapon.equipped_slot_2 = true
		#item.catalogue_text.slot_1.set_pressed_no_signal(false)
		
		
func on_stock_price_hovered(_time: float, stock_value: float, weapon: WeaponData, stock: WeaponStock):
	description.display_buy_menu(weapon, stock_value)
	
	var rect = stock.get_global_rect()
	move_description(Vector2(rect.position.x + rect.size.x + 25, rect.position.y))
	$Catalogue/MenuTab.deselect()
	$Perks.get_node("MenuTab").deselect()
	
func on_stock_price_clicked(time: float, stock_value: float, weapon: WeaponData, stock: WeaponStock):
	## Check you have enough money
	
	var cost = int(weapon.base_price * stock_value) 
	if cost > inventory.spendable_money:
		# TODO sound
		return
		
	## create a new rental
	
	var rental := inventory.create_rental(weapon, time, stock_value)
	
	stock.add_rental(rental)
	
func on_rental_hovered(rental: Inventory.Rental, weapon: WeaponData):
	description.display_sell_menu(weapon, rental)

func on_rental_sold(rental: Inventory.Rental):
	inventory.sell_rental(rental)
	

func on_spendable_updated(new):
	$Money/Backdrop/spendable.text = "$" + str(new)

func on_tab_selected(tab):
	move_description(BOTTOM_SCREEN_MIDDLE)
	for tab2 in get_tree().get_nodes_in_group("MenuTab"):
		if tab2 == tab: continue
		tab2.deselect()

func move_description(g_position: Vector2):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(description, "position", g_position, 0.3)

func on_catalogue_weapon_hovered(control: Control, weapon: WeaponData):
	description.display_category(weapon)
	move_description(control.global_position + Vector2(200, 0))

func on_perk_hover(control: Control, perk: int):
	description.display_perk_menu(perk, control.perk_price, Perks.has_perk(perk))
	move_description(control.global_position - Vector2(350, 50))
	
func _on_dimming_1_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not event.is_pressed():
		move_description(OFF_SCREEN_MIDDLE)
		for tab in get_tree().get_nodes_in_group("MenuTab"):
			tab.deselect()
