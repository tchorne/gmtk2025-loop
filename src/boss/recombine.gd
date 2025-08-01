extends Area2D

@export var ignore: Area2D

@onready var statue: Statue = $".."

func _physics_process(_delta: float) -> void:
	if not statue.recombine: return
	
	var overlapping = get_overlapping_areas()
	for area in overlapping:
		if area == ignore: continue
		if not area.get_statue().recombine: continue
		if statue.size == area.get_statue().size:
			statue.recombine_with(area.get_statue())
