extends HBoxContainer

signal price_hovered(time: float, cost: float)

const TIME_CHUNKS = 50
@onready var color_rect: ColorRect = $ColorRect
@onready var line_2d: Line2D = $ColorRect/Line2D

@export var price_gradient : Gradient

var previous_hover := -1
var volatility := 1

var price_timeline : Array[float] = []

func _ready():
	generate_history()
	
func generate_history():
	var current_price = randf_range(0.3, 1.0)
	price_timeline.clear()
	
	var gradient := Gradient.new()
	gradient.interpolation_color_space = Gradient.GRADIENT_COLOR_SPACE_LINEAR_SRGB
	
	for i in range(TIME_CHUNKS):
		current_price += (randf()-0.5) * volatility
		current_price = clamp(current_price, 0.3, 1.0)
		price_timeline.append(current_price)
		var color = price_gradient.sample(current_price)
		
		gradient.add_point(i/49.0, color)
	
	line_2d.gradient = gradient
	
func apply_to_line():
	var i := 0
	var width = color_rect.get_global_rect().size.x
	var height = color_rect.get_global_rect().size.y
	var points2: PackedVector2Array = line_2d.points
	points2.resize(50)
	
	for price in price_timeline:
		var x = lerp(0.0, width, i/49.0)
		var y = lerp(8.0, height-8.0, price)
		points2[i] = Vector2(x,y)
		i += 1
	line_2d.points = points2

func _process(delta: float) -> void:
	apply_to_line()


func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		$ColorRect/HoveredTime.visible = true
		var t = event.position.x / color_rect.get_global_rect().size.x
		var snap_point = int(round(t*TIME_CHUNKS))
		
		snap_point = clamp(snap_point, 0, TIME_CHUNKS-1)
		var snapped_t = float(snap_point)/TIME_CHUNKS * color_rect.get_global_rect().size.x
		$ColorRect/HoveredTime.position.x = snapped_t
		if snap_point != previous_hover:
			previous_hover = snap_point
			price_hovered.emit(snapped_t, price_timeline[snap_point])
		Cursor.clickable_hovered()

func _on_color_rect_mouse_exited() -> void:
	$ColorRect/HoveredTime.visible = false
	Cursor.clickable_unhovered()
	
