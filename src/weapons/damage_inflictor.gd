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

func is_weapon(n):
	return get_parent().name == n or name == n+"Inf"

func _on_statue_hit(statue: Statue):
	if not enabled: return
	
	statue.take_damage(damage 
		* (1.5 if (is_weapon("Chair") and Perks.has_perk(Perks.TITANIUM_CHAIR)) else 1)
		* (2 if (is_weapon("Fan") and Perks.has_perk(Perks.OZONE)) else 1)
		* (2 if (is_weapon("Flamethrower") and Perks.has_perk(Perks.HOTTER_GAS)) else 1)
		* (2 if (is_weapon("Bullet") and Perks.has_perk(Perks.HEAVY_BULLETS)) else 1)
	)
	statue.take_structure_damage(structure_damage 
		* (1.5 if (is_weapon("Chair") and Perks.has_perk(Perks.TITANIUM_CHAIR)) else 1)
	)
	statue.add_element(element, element_amount
		* (1000 if (is_weapon("Shield") and Perks.has_perk(Perks.GRAVITRONS)) else 1)
	)
	
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
