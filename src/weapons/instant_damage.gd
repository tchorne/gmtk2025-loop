extends Node

signal hit_statue(statue: Statue)

@export var my_area: Area2D

func trigger_hit():
	for area in my_area.get_overlapping_areas():
		if area.has_method("get_statue"):
			var statue := area.get_statue() as Statue
			hit_statue.emit(statue)
