extends Node2D

@onready var player: CharacterBody2D = $".."
@onready var pivot: Node2D = $Pivot
@onready var inventory := Inventory.get_inventory(self)

@onready var flamethrower: Node2D = $Pivot/Flamethrower
@onready var hook: Node2D = $Pivot/Hook
@onready var chair: Node2D = $Pivot/Chair
@onready var fan: Node2D = $Pivot/Fan
@onready var taser: Node2D = $Pivot/Taser
@onready var minigun: Node2D = $Pivot/Minigun
@onready var office_supplies: Node2D = $Pivot/OfficeSupplies
@onready var orbital_laser: Node2D = $Pivot/OrbitalLaser
@onready var shield: Node2D = $Pivot/Shield
@onready var melee: Node2D = $Pivot/Melee

const NUM_WEAPONS = 9
var weapons : Array[Node2D] = []

var slot_1 := NUM_WEAPONS-1
var slot_2 := NUM_WEAPONS-1

var cooldown := 0.0

func _ready():
	weapons = [
		chair, office_supplies, fan, taser, minigun, flamethrower, shield, orbital_laser, melee
	]
	inventory.begin_rental.connect(on_rental_begin)
	inventory.end_rental.connect(on_rental_end)

func on_rental_begin(weapon: String, slot: int):
	var weapon_index = weapons.find_custom(func(x): 
		return (x.name == weapon)
	)
	assert(weapon_index != -1, "NO WEAPON FOUND")
	if slot == 1:
		slot_1 = weapon_index
	else:
		slot_2 = weapon_index

func on_rental_end(slot: int):
	if slot == 1:
		slot_1 = weapons.size()-1
	else:
		slot_2 = weapons.size()-1

func _process(delta: float) -> void:
	handle_debug_equips()
	var statue_vector := get_mouse_vector()
	
	if statue_vector == Vector2.ZERO:
		pivot.rotation = 0
	else:
		pivot.rotation = statue_vector.angle() if statue_vector.x > 0 else PI + statue_vector.angle()
	for weapon in weapons:
		weapon.visible = false
		if weapon.has_method("set_active"):
			weapon.set_active(false)
		if weapon.has_method("set_nearest_statue_vector"):
			weapon.set_nearest_statue_vector(statue_vector)
		
	cooldown -= delta * Hitstun.deltamod()
	
	if Input.is_action_pressed("medatk") and cooldown < 0:
		weapons[slot_1].visible = true
		if weapons[slot_1].has_method("set_active"):
			weapons[slot_1].set_active(true)
	
	if Input.is_action_pressed("lightatk") and cooldown < 0 and not Input.is_action_pressed("medatk"):
		weapons[slot_2].visible = true
		if weapons[slot_2].has_method("set_active"):
			weapons[slot_2].set_active(true)

func get_nearest_statue_vector() -> Vector2:
	var statues = get_tree().get_nodes_in_group("Statue")
	if statues.is_empty():
		return Vector2.ZERO
	
	var vectors = statues.map(func(statue): return statue.global_position - global_position)
	vectors = vectors.filter(func(vector): return vector.x >= 0 == player.facing_right)
	if vectors.is_empty():
		return Vector2.ZERO
	var nearest = vectors.reduce(func(m, vec): return m if is_length_greater(vec, m) else vec) as Vector2
	return nearest.normalized()

func get_mouse_vector() -> Vector2:
	var out := (get_viewport().get_camera_2d().get_global_mouse_position() - global_position).normalized()
	if out.x >= 0 != player.facing_right:
		return Vector2.ZERO
	return out
	
func is_length_greater(a, b):
	return a.length() > b.length()

func handle_debug_equips():
	if Input.is_key_label_pressed(KEY_1):
		slot_1 = -1
	if Input.is_key_label_pressed(KEY_2):
		slot_1 = 0
	if Input.is_key_label_pressed(KEY_3):
		slot_1 = 1
	if Input.is_key_label_pressed(KEY_4):
		slot_1 = 2
	if Input.is_key_label_pressed(KEY_5):
		slot_1 = 3
	if Input.is_key_label_pressed(KEY_6):
		slot_1 = 4
	if Input.is_key_label_pressed(KEY_7):
		slot_1 = 5
	if Input.is_key_label_pressed(KEY_8):
		slot_1 = 6
	if Input.is_key_label_pressed(KEY_9):
		slot_1 = 7
