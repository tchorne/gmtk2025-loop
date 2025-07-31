extends Control

const TICKS_IN_DAY := 10
const STOCK_TICK = preload("res://src/schedule/stock_tick.tscn")

@onready var progress_tick = $MarginContainer/VBoxContainer/Schedule/DayTime

@onready var stock_color_rects = [
	$MarginContainer/VBoxContainer/Schedule2,
	$MarginContainer/VBoxContainer/Schedule3,
	$MarginContainer/VBoxContainer/Schedule4,
	$MarginContainer/VBoxContainer/Schedule5
]

@onready var game_state := GameState.get_state(self)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for stock in stock_color_rects:
		var container = stock.get_child(0)
		for i in TICKS_IN_DAY:
			var tick = STOCK_TICK.instantiate()
			tick.value = smoothstep(0,1,randf())
			container.add_child(tick)
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var rect := $MarginContainer/VBoxContainer/Schedule.get_rect() as Rect2
	progress_tick.position.x = lerp(rect.position.x, rect.position.x + rect.size.x, game_state.day_progress)
