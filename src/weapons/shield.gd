extends Node2D

@onready var continuous_damage: Node = $ContinuousDamage
@onready var shield: AudioStreamPlayer = $Shield

var active := false
func set_active(a):
	continuous_damage.active = a
	active = a
	if not shield.playing:
		shield.play()

func _process(delta: float) -> void:
	shield.volume_linear = 0.7 if active else 0
