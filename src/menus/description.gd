extends TextureRect

@onready var item_name: Label = $ItemName
@onready var buy_rental: Control = $BuyRental
@onready var rental_text: Label = $BuyRental/RentalText
@onready var buy: Control = $BuyRental/Buy
@onready var sell: Control = $BuyRental/Sell
@onready var catalogue: Control = $Catalogue
@onready var description: Label = $Catalogue/Description
@onready var price: Label = $BuyRental/Price

func display_buy_menu(data: WeaponData, stock_price: float):
	buy_rental.visible = true
	catalogue.visible = false
	buy.visible = true
	sell.visible = false
	
	item_name.text = data.get_display_name()
	price.text = "$" + str(int(data.base_price * stock_price))
	
	pass

func display_sell_menu(data: WeaponData, rental: Inventory.Rental):
	buy_rental.visible = true
	catalogue.visible = false
	buy.visible = false
	sell.visible = true
	
	item_name.text = data.display_name
	price.text = "$" + str(rental.price)
	pass

func display_category(data: WeaponData):
	buy_rental.visible = false
	catalogue.visible = true
	if not data.unlocked:
		item_name.text = "???"
		description.text = "Earn ${0} in one day to unlock".format([int(data.unlock_price)])
	else:
		item_name.text = data.display_name
		description.text = data.description
