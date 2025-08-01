extends Node2D
@onready var continuous_damage: Node = $ContinuousDamage

func set_active(a):
	continuous_damage.active = a
	
	
