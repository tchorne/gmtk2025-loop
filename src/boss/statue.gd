extends Node2D

const STATUE = preload("res://src/boss/statue.tscn")
const COIN = preload("res://src/boss/Coin.tscn")

@onready var world: Node2D = $".."
@onready var rigid_body: RigidBody2D = $Physics/RigidBody
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hitflash: Timer = $Hitflash

var size: int = 6

var physics_mode := true

var stored_knockback := Vector2.ZERO
var stored_forces: Array[Vector2] = []

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.has_method("on_hit"):
		area.on_hit(self)

func lock_until_combo_ended():
	return
	physics_mode = false

func extend_lock():
	pass

func add_knockback(force: Vector2):
	if physics_mode:
		rigid_body.apply_central_impulse(force)
	else:
		stored_forces.append(force)
	
func take_damage(amount: float = 1):
	sprite_2d.modulate = Color.WHITE * 10
	hitflash.start()
	for i in range(4):
		call_deferred("create_coin")
	
func enter_physics():
	if (not physics_mode): global_position = rigid_body.global_position
	physics_mode = true
	
	stored_forces.sort_custom(func(a: Vector2,b: Vector2): return a.length_squared() > b.length_squared())
	var decay := 1.0
	for force in stored_forces:
		rigid_body.apply_central_impulse(force / decay)
		decay += 1.0
	
	stored_forces.clear()

func create_coin():
	var coin = COIN.instantiate()
	world.add_child(coin)
	coin.scale = Vector2.ONE * 0.2
	coin.global_position = global_position

func split():
	if (size == 1): return
	var other = STATUE.instantiate()
	get_parent().add_child(other)
	set_size(size-1)
	other.set_size(size)
	other.set_transform_(global_transform)

func set_size(s: int):
	size = s
	sprite_2d.frame = 6-size
	$Area2D/CollisionShape2D.scale = Vector2.ONE * (size/6.0)
	$Physics/RigidBody/CollisionShape2D.scale = Vector2.ONE * (size/6.0)

func set_transform_(other: Transform2D):
	global_transform = other
	rigid_body.global_transform = other
	
func _process(_delta: float) -> void:
	if physics_mode:
		global_position = rigid_body.global_position
		global_rotation = rigid_body.global_rotation
	else:
		rigid_body.global_position = global_position


func _on_hitflash_timeout() -> void:
	sprite_2d.modulate = Color.WHITE


func _on_player_combo_dropped() -> void:
	enter_physics()
