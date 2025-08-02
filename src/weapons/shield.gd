extends Node2D

@onready var continuous_damage: Node = $ContinuousDamage
@onready var shield: AudioStreamPlayer = $Shield

func set_active(a):
	continuous_damage.active = a
	
	shield.volume_linear = 0.7 if a else 0
