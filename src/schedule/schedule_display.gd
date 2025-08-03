extends Control

#@onready var progress_tick = $MarginContainer/VBoxContainer/Schedule/DayTime
@onready var day_progress: TextureProgressBar = %DayProgress

@onready var game_state := GameState.get_state(self)
@onready var rentals_box: Control = $DayProgress/Rentals
const WEAPON_DISPLAY = preload("res://src/schedule/weapon_display.tscn")

func _process(_delta: float) -> void:
	day_progress.value = game_state.time
	pass

func set_rentals():
	var rentals := Inventory.get_inventory(self).rentals
	
	for child in rentals_box.get_children():
		child.queue_free()
		
	for rental in rentals:
		var wep = WEAPON_DISPLAY.instantiate()
		rentals_box.add_child(wep)
		wep.position.x = rentals_box.get_rect().size.x * rental.start_time
		wep.get_node("Weapon").texture = Inventory.get_inventory(self).get_weapon_by_string(rental.weapon).image
