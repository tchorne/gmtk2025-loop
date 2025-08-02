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
	statue.take_damage(damage)
	statue.take_structure_damage(structure_damage)
	statue.add_element(element, element_amount)
	
	if play_sound:
		play_sound.play()
		
	if hitstun > 0.0:
		Hitstun.extend_hitstun(hitstun)
		
	if knockback_towards_mouse and knockback_strength > 0.01:
		var mouse_pos := get_viewport().get_camera_2d().get_global_mouse_position()
		var vec = -(statue.global_position - mouse_pos).normalized()
		statue.add_knockback(vec*knockback_strength)
	if knockback.length() > 0.01:
		statue.add_knockback(knockback)
