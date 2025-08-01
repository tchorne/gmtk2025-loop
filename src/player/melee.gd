extends Node2D

signal attack_ended

var current_attack := "MediumCombo"
var current_attack_string : AttackString = null

@onready var melee_anims: AnimationPlayer = $MeleeAnims
@onready var melee_attack_pos: Marker2D = $MeleeAttackPos
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var player: CharacterBody2D = $".."
@onready var melee_hitbox: Area2D = $Sprite2D/MeleeHitbox

var chained := false ## Has the player pressed the attack button since the last one went through?
var last_input := ""
var in_attack := false
var attack_cooldown := 0.0

func begin_attack():
	in_attack = true
	chained = true
	current_attack = "MediumCombo"
	current_attack_string = AttackString.new(current_attack)
	melee_anims.play(current_attack)
	

func _process(delta: float) -> void:
	attack_cooldown -= delta  * Hitstun.deltamod()
	
	if Input.is_action_just_pressed("lightatk"):
		last_input = "lightatk"
		if in_attack and current_attack_string.attacks.size() > 0:
			chained = true
		
		if not in_attack and attack_cooldown < 0:
			begin_attack()

## Called by animation
func next_attack():
	if !chained:
		in_attack = false
		melee_anims.stop()
		sprite_2d.visible = false
		current_attack_string = null
		attack_ended.emit()
		return
	
	chained = false
	sprite_2d.visible = true
	var attack = current_attack_string.pop()
	sprite_2d.position = melee_attack_pos.position
	if not player.facing_right:
		sprite_2d.position.x *= -1
	sprite_2d.scale = attack["size"]
	melee_hitbox.trigger_hit()
	

## Called by animation
func end_attack():
	chained = false
	in_attack = false
	sprite_2d.visible = false
	attack_cooldown = current_attack_string.cooldown
	melee_anims.stop()
	attack_ended.emit()
	current_attack_string = null
	
class AttackString:
	var attacks: Array[Dictionary]
	var cooldown: float
	
	func _init(template: String) -> void:
		attacks = []
		
		match(template):
			"MediumCombo":
				add(1, 1).add(1, 1).add(2, 2)
				cooldown = 0.5
				
	func add(size: float, damage: float, movement: Dictionary = {}) -> AttackString:
		attacks.push_back({
			"size": Vector2.ONE * size,
			"damage": damage,
			"movement": movement
		})
		return self
		
		
	func pop():
		return attacks.pop_front()
		


func _on_melee_anims_animation_finished(_anim_name: StringName) -> void:
	if in_attack:
		print_debug("Still in attack at animation end")
		in_attack = false
