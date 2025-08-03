extends TextureButton

@export var timeline_label := ""

@onready var original_position = position
var t := 0.0
var moving := true
func _on_pressed() -> void:
	Dialogic.start("tutorials", timeline_label)
	moving = false
	position = original_position

func _process(delta: float) -> void:
	if not moving: return
	
	t += delta * 2
	position = original_position + Vector2.UP * sin(t) * 5
