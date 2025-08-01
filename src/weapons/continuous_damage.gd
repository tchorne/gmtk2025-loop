extends Node

## Deals some amound of damage at a rate
signal hit_statue(statue: Statue)

@export var tick_rate: float ## Instances of damage per second
@export var area: Area2D
@export var active: bool

var time_to_next := 0.0
func _process(delta: float) -> void:
	if active:
		time_to_next -= delta * Hitstun.deltamod()
		if time_to_next <= 0.0:
			time_to_next += 1.0 / tick_rate
			check_hit()

func check_hit():
	for a in area.get_overlapping_areas():
		if a.has_method("get_statue"):
			var statue = a.get_statue() as Statue
			hit_statue.emit(statue)
			
