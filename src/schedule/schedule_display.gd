extends Control

#@onready var progress_tick = $MarginContainer/VBoxContainer/Schedule/DayTime
@onready var day_progress: TextureProgressBar = %DayProgress

@onready var game_state := GameState.get_state(self)

func _process(_delta: float) -> void:
	day_progress.value = game_state.time
	pass
