class_name Statue
extends Node2D

const STATUE = preload("res://src/boss/statue.tscn")
const COIN = preload("res://src/boss/Coin.tscn")
const COIN_VALUES = [1,2,5,10,20,50,100]
const SPLIT_TIME = 6.0

@onready var world: Node2D = $".."
@onready var rigid_body: RigidBody2D = $Physics/RigidBody
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hitflash: Timer = $Hitflash
@onready var element_controller: Control = %ElementController
@onready var damaging_reset: Timer = $DamagingReset
@onready var recombine_timer: Timer = $Recombine/RecombineTimer


var rotate_speed := 0.0
var structure_health := 100.0
var size: int = 6
var damaging := true
var rest_position := Vector2.ZERO
var recombine := true
var physics_mode := true

var stored_knockback := Vector2.ZERO
var stored_forces: Array[Vector2] = []

var eraticness := 0.0
var total_damage_recieved = 0

func _ready():
	total_damage_recieved = 0
	rigid_body.global_transform = global_transform
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.has_method("on_hit"):
		area.on_hit(self)

func _physics_process(_delta: float) -> void:
	if eraticness > 100 and rigid_body.linear_velocity.length() < 100:
		# launch in a random direction
		rigid_body.apply_central_impulse(Vector2.RIGHT.rotated(randf_range(0, TAU)) * eraticness * log(eraticness))
	if (rest_position - global_position).length() > 100:
		rest_position = global_position
		eraticness = 0
	eraticness = max(eraticness, 0)
	

func lock_until_combo_ended():
	return

func extend_lock():
	pass

func take_structure_damage(damage: float):
	structure_health -= damage
	if structure_health <= 0.0:
		structure_health = 9999999
		call_deferred("split")

func add_element(element: Element.Element, amount := 1.0):
	element_controller.add_element(element, amount)

func add_knockback(force: Vector2):
	force += force.length() * Vector2.UP * 0.7
	force = force * force_multiplier()
	rigid_body.apply_central_impulse(force) 
	damaging = false
	damaging_reset.start(0.5)
	
	
func take_damage(amount: float = 1):
	eraticness += amount
	sprite_2d.modulate = Color.WHITE * 10
	hitflash.start()
	total_damage_recieved += amount
	
	var damage_remaining := int(amount
		* (1.05 if Perks.has_perk(Perks.STRENGTH) else 1)
	)
	while damage_remaining > 0:
		var value = COIN_VALUES.pick_random()
		if value > damage_remaining: continue
		call_deferred("create_coin", value)
		damage_remaining -= value

func create_coin(value: int):
	var coin = COIN.instantiate()
	world.add_child(coin)
	coin.scale = Vector2.ONE * 0.2
	coin.global_position = global_position
	coin.set_value(value)

func split():
	if (size == 1): return
	var other = STATUE.instantiate()
	get_parent().add_child(other)
	total_damage_recieved = 0
	set_size(size-1)
	other.set_size(size)
	other.set_transform_(global_transform)
	other.sprite_2d.flip_h = not sprite_2d.flip_h
	recombine = false
	other.recombine = false
	recombine_timer.start(SPLIT_TIME)
	other.recombine_timer.start(SPLIT_TIME)

func recombine_with(other: Statue):
	if get_tree().get_first_node_in_group("Hook").latched == other:
		get_tree().get_first_node_in_group("Hook").latched = null
		get_tree().get_first_node_in_group("Hook").taser.extended = false
		
	other.queue_free()
	other.recombine = false
	set_size(size+1)
	rigid_body.global_position += Vector2.UP * 100
	rigid_body.linear_velocity = (other.rigid_body.linear_velocity + rigid_body.linear_velocity) / 2
	
func set_size(s: int):
	size = s
	structure_health = 100
	for i in range(6-size):
		structure_health *= 2
	sprite_2d.frame = 6-size
	var new_scale = (size/6.0)
	if size < 6:
		new_scale *= 0.8
	if size < 5:
		new_scale *= 0.8
	$Area2D/CollisionShape2D.scale = Vector2.ONE * new_scale
	$Physics/RigidBody/CollisionShape2D.scale = Vector2.ONE * new_scale
	rigid_body.physics_material_override.bounce = (7.0-size)/6.0

func set_transform_(other: Transform2D):
	global_transform = other
	if rigid_body:
		rigid_body.global_transform = other
	
func _process(delta: float) -> void:
	hitflash.process_mode = Node.PROCESS_MODE_DISABLED if Hitstun.paused else Node.PROCESS_MODE_INHERIT
	if physics_mode:
		global_position = rigid_body.global_position
		global_rotation = rigid_body.global_rotation
	else:
		rigid_body.global_position = global_position
	sprite_2d.rotation += rotate_speed * delta * Hitstun.deltamod()

func force_multiplier():
	return max(1, log(total_damage_recieved))

func _on_hitflash_timeout() -> void:
	sprite_2d.modulate = Color.WHITE


func _on_bounce_detector_bounced() -> void:
	if rigid_body.global_position.y < 100:
		rigid_body.linear_velocity *= 1.3
		rotate_speed = rigid_body.linear_velocity.length() / 300 * (1 if (randf() > 0.5) else -1) * (7 - size)
	else:
		rotate_speed = 0.0
		sprite_2d.rotation = 0.0


func _on_damaging_reset_timeout() -> void:
	damaging = true


func _on_recombine_timer_timeout() -> void:
	recombine = true
