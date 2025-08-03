extends Control


@onready var game_state := GameState.get_state(self)
@onready var knob: TextureRect = $knob
@onready var sprite_2d: Sprite2D = $Sprite2D


const LEVEL_QUOTA_MULTS = {
	1: 1.2,
	2: 1.6,
	3: 2.0,
	4: 3.0
}

const LEVEL_INCOME_MULTS = {
	1: 1.0,
	2: 1.3,
	3: 1.7,
	4: 2.0
}


var level := 1

func _ready():
	game_state.begin_day.connect(add_eval_day)
	game_state.freeplay_started.connect(update)

func add_eval_day():
	if level == 4:
		game_state.eval_day += 1
		
func update():
	game_state.income_mult = LEVEL_INCOME_MULTS[level]
	game_state.quota_mod = LEVEL_QUOTA_MULTS[level]
	$"../Info2/Earnings".text = "$" + str(int(game_state.total_earnings))
	$Quota.text = "$" + str(int(game_state.get_quota()))
	var days_left = game_state.eval_day - game_state.day_number
	if game_state.freeplay:
		$"../Info2/Review".text = "[color=black]Freeplay Mode"
	else:
		if days_left >= 2:
			var display_count = "[color=red]{0}[/color]".format([ days_left ])
			if level == 4:
				display_count = "[color=orangered][{0}][/color]".format([ days_left + 1 ])
			$"../Info2/Review".text = "[color=black]Performance Review in {0} loops".format([ display_count ])
		else:
			$"../Info2/Review".text = "Performance Review [color=red]next loop[/color]!"
	$Review.text = "Income Multiplier: %0.2fx" % [game_state.income_mult]
	$Review2.text = "Next Quota = Previous x %0.2fx" % [game_state.quota_mod]
	
	knob.rotation = (level-1) * TAU/9
	sprite_2d.frame = level-1
	
func _on_knob_gui_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton: return
	if not event.is_released(): return
	if event.button_index == MOUSE_BUTTON_LEFT:
		level -= 1
	elif event.button_index == MOUSE_BUTTON_RIGHT:
		level += 1
	level = clamp(level, 1, 4)
	update()
	
