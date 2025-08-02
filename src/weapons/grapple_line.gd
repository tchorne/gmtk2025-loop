extends Line2D

@export var node_1 : Node2D
@export var node_2 : Node2D
@onready var pivot: Node2D = $"../Pivot"

@export var color_1 : Color
@export var color_2: Color

var swap := false

func _process(delta: float) -> void:
	var new_points: PackedVector2Array = []
	new_points.append(node_1.global_position)
	new_points.append(node_2.global_position)
	
	points = new_points


func _on_timer_timeout() -> void:
	if pivot.latched:
		swap = not swap
	refresh()
	
func refresh():
	default_color = color_1 if not swap else color_2
