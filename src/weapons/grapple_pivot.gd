extends Node2D

const Taser = preload("res://src/weapons/taser.gd")
@onready var taser: Taser = $"../.."
@export var distance_curve: Curve
@onready var electric_inflictor: Node = $"../../ElectricInflictor"
@export var knocktowards := 15.0
var launch_pos := Vector2.ZERO
var target_pos := Vector2.ZERO
var time_since_launch := 0.0

var latched: Statue

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if taser.extended:
		if is_instance_valid(latched):
			global_position = latched.global_position
			electric_inflictor.knockback = (taser.global_position - global_position).normalized() * knocktowards
		else:
			if time_since_launch > 1.58:
				global_position = lerp(taser.global_position, target_pos, distance_curve.sample_baked(time_since_launch))
				rotation = (target_pos - taser.global_position).angle()
			else:
				global_position = lerp(launch_pos, target_pos, distance_curve.sample_baked(time_since_launch))
				rotation = (target_pos - launch_pos).angle()
				
		time_since_launch += (delta * Hitstun.deltamod()
			/ (1.5 if Perks.has_perk(Perks.BARBED_HOOKS) else 1.0)
		)
		if time_since_launch > distance_curve.max_domain:
			taser.extended = false
			latched = null
		
func _on_continuous_damage_hit_statue(statue: Statue) -> void:
	if not is_instance_valid(latched):
		$"../../InstantDamage".trigger_hit()
		time_since_launch -= 2.0
		latched = statue
	
