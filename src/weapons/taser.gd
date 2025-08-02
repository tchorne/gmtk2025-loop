extends Node2D

var extended := false
@onready var pivot: Node2D = $Global/Pivot
@onready var sprite_2d: Sprite2D = $Sprite2D
@export var max_length := 600
@onready var electric_inflictor: Node = $ElectricInflictor
@onready var continuous_damage: Node = $ContinuousDamage
@onready var line_2d: Line2D = $Global/Line2D

func set_active(a):
	if a:
		if extended == false:
			launch()
	continuous_damage.active = a or extended
	
func _process(_delta: float) -> void:
	if not extended:
		pivot.global_transform = global_transform
	pivot.visible = sprite_2d.is_visible_in_tree() or extended
	line_2d.visible = pivot.visible
func launch():
	extended = true
	pivot.launch_pos = pivot.global_position
	pivot.target_pos = get_viewport().get_camera_2d().get_global_mouse_position()
	
	pivot.target_pos = pivot.launch_pos + ((pivot.target_pos - pivot.launch_pos) as Vector2).limit_length(max_length)
	
	pivot.time_since_launch = 0.0
	$Global/Line2D.refresh()
