extends Node

@onready var sprite: Sprite2D = get_parent()

const CAPTURE_RATE = 1.0 / 2.0

var time_to_next = CAPTURE_RATE

func _ready():
	sprite.add_to_group("Rewindable")
		
	
func _process(delta: float) -> void:
	pass

func create_rewind_ghost():
	pass
