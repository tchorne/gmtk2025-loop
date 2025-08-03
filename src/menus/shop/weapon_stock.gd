extends HBoxContainer

signal price_hovered(time: float, cost: float)
signal price_clicked(time: float, cost: float)
signal rental_sold(rental: Inventory.Rental)
signal rental_hovered(rental: Inventory.Rental)


const RENTAL_BLOCK = preload("res://src/menus/shop/rental_block.tscn")
const TIME_CHUNKS = 50


@onready var color_rect: TextureRect = $ColorRect
@onready var line_2d: Line2D = $ColorRect/Line2D
@onready var texture_rect: TextureRect = $Control/TextureRect
@onready var line_2d_2: Line2D = $ColorRect/Line2D2

@export var price_gradient : Gradient
var modifier = 1.0

var min_discount := 0.3
var max_markup := 2.4

static var num := 0
var mynum = 0
var previous_hover := -1
var volatility := 1

var price_timeline : Array[float] = []
var rental_blocks: Array[RentalBlock]

var my_data: WeaponData

func load_weapon(data: WeaponData):
	texture_rect.texture = data.image
	visible = data.unlocked
	my_data = data

func _ready():
	num += 1
	mynum = num
	$Control/TextureRect2.flip_h = num%2 == 0
	$ColorRect/ColorRect.flip_h = num%2 == 0
	generate_history()

func set_hand():
	$Control/left.visible = my_data.equipped_slot_1
	$Control/right.visible = not $Control/left.visible

func generate_history(iseed=-1):
	if iseed == -1:
		randomize()
	else:
		seed(iseed + my_data.weapon_index)
	var current_price = randf_range(0.3, 1.0)
	price_timeline.clear()
	
	var gradient := Gradient.new()
	gradient.interpolation_color_space = Gradient.GRADIENT_COLOR_SPACE_LINEAR_SRGB
	gradient.remove_point(0)
	
	for i in range(TIME_CHUNKS):
		current_price += (randf()-0.5) * volatility
		current_price = clamp(current_price, 0.3, 1.0)
		price_timeline.append(current_price)
		var color = price_gradient.sample(current_price)
		
		gradient.add_point(i/49.0, color)
	
	line_2d.gradient = gradient
	call_deferred("apply_to_line")

func set_modifier(base_price, money_earned): ## at it's cheapest, any weapon should be at least 5% of your spending money
	
	var s = min_discount * base_price / float(money_earned)
	s /= 0.05
	s = max(1.0/s, 1)
	
	modifier = s
	pass
	
func get_price(price_point): ## remaps 0.3 to 1.0 to something else
	return remap(price_timeline[price_point], 0.3, 1.0, min_discount, max_markup) * modifier

func apply_to_line():
	var i := 0
	var width = color_rect.get_global_rect().size.x
	var height = color_rect.get_global_rect().size.y
	var points2: PackedVector2Array = line_2d.points
	points2.resize(50)
	
	for price in price_timeline:
		var x = lerp(0.0, width, i/49.0)
		var y = lerp(height-8.0, 8.0, price)
		points2[i] = Vector2(x,y)
		i += 1
	line_2d.points = points2
	line_2d_2.points = points2

func _process(_delta: float) -> void:
	apply_to_line()
	set_hand()
	pass


func _on_color_rect_gui_input(event: InputEvent) -> void:
	var stock_width = color_rect.get_global_rect().size.x
	if event is InputEventMouseMotion:
		$ColorRect/HoveredTime.visible = true
		# Get Points
		var t = event.position.x / stock_width
		var snap_point = int(round(t*TIME_CHUNKS))
		snap_point = clamp(snap_point, 0, TIME_CHUNKS-1)
		var snapped_t = float(snap_point)/TIME_CHUNKS
		#
		$ColorRect/HoveredTime.position.x = snapped_t * stock_width
		if snap_point != previous_hover:
			previous_hover = snap_point
			price_hovered.emit(snapped_t, get_price(snap_point))
		Cursor.clickable_hovered()
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.is_pressed():
		# Get points
		var t = event.position.x / stock_width
		var snap_point = int(round(t*TIME_CHUNKS))
		snap_point = clamp(snap_point, 0, TIME_CHUNKS-1)
		var snapped_t = float(snap_point)/TIME_CHUNKS
		#
		price_clicked.emit(snapped_t, get_price(snap_point))
		
func _on_color_rect_mouse_exited() -> void:
	$ColorRect/HoveredTime.visible = false
	Cursor.clickable_unhovered()

func add_rental(r: Inventory.Rental):
	var rect: TextureRect = RENTAL_BLOCK.instantiate()
	$ColorRect.add_child(rect)
	$ColorRect.move_child(rect, 0)
	
	var line_pos_1 =  r.start_time * color_rect.get_global_rect().size.x
	var line_pos_2 = r.end_time * color_rect.get_global_rect().size.x
	
	var rect_size = Vector2(line_pos_2 - line_pos_1, color_rect.get_global_rect().size.y )
	rect.position = Vector2(line_pos_1, 0)
	rect.size = rect_size
	rect.get_child(0).flip_h = mynum%2==0
	
	var block := RentalBlock.new()
	block.display = rect
	block.rental = r
	block.rental
	
	rental_blocks.append(block)
	block.rental.deleted.connect(sell_rental.bind(block.rental))
	
	block.display.gui_input.connect(handle_rental_block_input.bind(block))
	

func sell_rental(r: Inventory.Rental):
	for i in len(rental_blocks):
		if rental_blocks[i].rental == r:
			rental_blocks[i].display.queue_free()
			rental_blocks.remove_at(i)
			break

func handle_rental_block_input(event: InputEvent, block: RentalBlock):
	if event is InputEventMouseMotion:
		rental_hovered.emit(block.rental)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and not event.is_pressed():
		rental_sold.emit(block.rental)
		sell_rental(block.rental)

class RentalBlock:
	var display: TextureRect
	var rental: Inventory.Rental
	
