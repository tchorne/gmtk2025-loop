extends Node2D

@export var calldown_begin : Color
@export var calldown_end: Color
@export var calldown_color: Curve
@export var beam_color: Curve

@onready var base: Node2D = $Lazer/Base
@onready var beam: Node2D = $Lazer/Base/Beam
@onready var flare: Node2D = $Lazer/Base/Flare
@onready var continuous_damage: Node = $ContinuousDamage


var calldown_position := Vector2.ZERO

var calldown_time := 0.0

var active := false

func set_active(a):
	if a:
		active = true
		base.visible = true
		
		if calldown_time < 3.5:
			var mouse_pos = get_viewport().get_camera_2d().get_global_mouse_position()
			base.global_position = Vector2(
				clamp(mouse_pos.x, -500, 500),
				250
			)


func _process(delta: float):
	if active:
		calldown_time += (delta * Hitstun.deltamod() * 2.0
			* (1.5 if (calldown_time < 3.5 and Perks.has_perk(Perks.ON_DEMAND)) else 1.0)
		) 
		flare.modulate = lerp(calldown_begin, calldown_end, calldown_color.sample(calldown_time))
		beam.modulate = lerp(calldown_begin, calldown_end, beam_color.sample(calldown_time))
	
	continuous_damage.active = active and calldown_time > 5.5
	
	if calldown_time > 10.0:
		active = false
		base.visible = false
		calldown_time = 0.0
