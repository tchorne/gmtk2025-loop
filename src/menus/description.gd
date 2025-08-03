extends TextureRect

@onready var item_name: Label = $ItemName
@onready var buy_rental: Control = $BuyRental
@onready var rental_text: Label = $BuyRental/RentalText
@onready var buy: Control = $BuyRental/Buy
@onready var sell: Control = $BuyRental/Sell
@onready var catalogue: Control = $Catalogue
@onready var description: Label = $Catalogue/Description
@onready var price: Label = $BuyRental/Price
@onready var perk: Control = $Perk

func hide_all():
	buy_rental.visible = false
	buy.visible = false
	sell.visible = false
	catalogue.visible = false
	perk.visible = false
	$Perk/Sell.visible = false
	$Perk/Buy.visible = false
	
func display_buy_menu(data: WeaponData, stock_price: float):
	hide_all()
	buy_rental.visible = true
	buy.visible = true
	
	item_name.text = data.get_display_name()
	price.text = "$" + str(int(data.base_price * stock_price))
	
	pass

func display_sell_menu(data: WeaponData, rental: Inventory.Rental):
	hide_all()
	buy_rental.visible = true
	sell.visible = true
	
	item_name.text = data.display_name
	price.text = "$" + str(rental.price)
	pass

func display_category(data: WeaponData):
	hide_all()
	catalogue.visible = true
	if not data.unlocked:
		item_name.text = "???"
		description.text = "Earn ${0} in one day to unlock".format([int(data.unlock_price)])
	else:
		item_name.text = data.display_name
		description.text = data.description

func display_perk_menu(perk_: int, cost: int, owned := false):
	hide_all()
	perk.visible = true 
	$Perk/Price.text = "$" + str(cost)
	item_name.text = Perks.PERK_NAMES[perk_]
	$Perk/Description.text = Perks.PERK_DESCRIPTIONS[perk_]
	if not owned:
		$Perk/Buy.visible = true
	else:
		$Perk/Sell.visible = true
	
