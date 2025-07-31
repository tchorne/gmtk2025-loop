extends Node

@onready var sprite: Sprite2D = get_parent()

const CAPTURE_RATE = 1.0 / 10.0

var time_to_next = CAPTURE_RATE

var ghost : Rewind.Ghost

@onready var rewind := Rewind.get_rewind(self)
@onready var game_state := GameState.get_state(self)

func _ready():
	sprite.add_to_group("Rewindable")
	ghost = rewind.add_ghost(sprite)
	
func _process(delta: float) -> void:
	time_to_next -= delta
	if time_to_next < 0:
		capture()
		time_to_next += CAPTURE_RATE
		
func capture():
	var newState := Rewind.PastState.new()
	newState.frame_coords = sprite.frame_coords
	newState.sprite_position = sprite.global_position
	newState.rotation = sprite.global_rotation
	newState.scale = sprite.global_scale
	newState.time = game_state.time
	newState.visible = sprite.visible
	ghost.history.append(newState)

func create_rewind_ghost():
	pass
