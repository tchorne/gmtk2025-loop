extends Node

@export var damage: float
@export var structure_damage: float
@export var element := Element.Element.NONE
@export var element_amount := 1.0
@export var knockback_away_from_player := true
@export var knockback_strength := 0.0
@export var knockback := Vector2.ZERO
@export var hitstun := 0.0

@export var play_sound: AudioStreamPlayer

func _on_statue_hit(statue: Statue):
	
	statue.take_damage(damage)
	statue.take_structure_damage(structure_damage)
	statue.add_element(element, element_amount)
	
	if play_sound:
		play_sound.play()
		
	if hitstun > 0.0:
		Hitstun.extend_hitstun(hitstun)
		
	if knockback_away_from_player and knockback_strength > 0.01:
		var player : CharacterBody2D = get_tree().get_first_node_in_group("Player")
		var vec = (statue.global_position - player.global_position).normalized()
		statue.add_knockback(vec*knockback_strength)
	if knockback.length() > 0.01:
		statue.add_knockback(knockback)
