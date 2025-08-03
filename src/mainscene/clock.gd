extends Control

@onready var rewind := Rewind.get_rewind(self)
@onready var texture_rect: TextureRect = $TextureRect
@onready var texture_rect_2: TextureRect = $TextureRect2

var speedmod := 1.0

func _ready() -> void:
	speedmod = 1.0 + randf()
	texture_rect.rotation = randf() * TAU
	texture_rect_2.rotation = randf() * TAU
	
	
func _process(delta: float) -> void:
	var reversed = -3 if rewind.rewinding else 1
	texture_rect.rotation += delta * speedmod * reversed
	texture_rect.rotation += delta * 1.5 * speedmod  * reversed
