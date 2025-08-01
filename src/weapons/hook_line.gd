@tool
extends Line2D

@onready var hook_1: Marker2D = $"../Hook2/Marker2D"
@onready var hook_2: Marker2D = $"../Hook1/Marker2D"

const POINTS = 10

var slack := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for point in POINTS:
		points[point] = to_local(lerp(hook_1.global_position, hook_2.global_position, point/float(POINTS)))
	points[POINTS] = to_local(hook_2.global_position)
