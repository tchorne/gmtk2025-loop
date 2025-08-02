extends Node

@export var damage: float
@export var structure_damage: float
@export var element := Element.Element.NONE
@export var element_amount := 1.0
@export var knockback_towards_mouse := true
@export var knockback_strength := 0.0
@export var knockback := Vector2.ZERO
@export var hitstun := 0.0
@export var enabled = true
@export var play_sound: AudioStreamPlayer

func _on_statue_hit(statue: Statue):
	if not enabled: return
	var damage_2 := damage
	var radial = (statue.global_position - get_parent().global_position).normalized()
	if statue.damaging and statue.rigid_body.linear_velocity.length() > 400:
		damage_2 *= 10.0
		structure_damage *= 2.0
		statue.rigid_body.linear_velocity = radial * statue.rigid_body.linear_velocity.length() * 1.2
	statue.take_damage(damage)
	statue.take_structure_damage(structure_damage)
	statue.add_element(element, element_amount)
	statue.add_knockback(knockback_strength * radial)
	
	if play_sound:
		play_sound.play()
		
	if hitstun > 0.0:
		Hitstun.extend_hitstun(hitstun)
		
	if knockback.length() > 0.01:
		statue.add_knockback(knockback * radial)
