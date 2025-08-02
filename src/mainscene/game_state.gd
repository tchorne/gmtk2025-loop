class_name GameState
extends Node

const STATUE = preload("res://src/boss/statue.tscn")
const DAY_LENGTH = 40.5

var time := 0.0
var money := 0.0
var quota := 1000.0
var playing := false
var firsttime := true

@onready var player_position: Vector2 = $"../World/Player".global_position
@onready var statue_spawn: Marker2D = %StatueSpawn
@onready var money_sounds: Node = $MoneySounds
@onready var inventory := Inventory.get_inventory(self)

func _ready():
	#begin_game()
	
	get_tree().process_frame.connect(func():
		#money = 25
		money = 10000
		end_game()
	, CONNECT_ONE_SHOT
	)
	
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_F2):
		get_tree().reload_current_scene()
	if playing:
		time += delta / DAY_LENGTH
		inventory.update_rentals(time)
	if time >= 1.0 and playing:
		end_game()
	
static func get_state(node: Node) -> GameState:
	return node.get_tree().get_first_node_in_group("GameState") as GameState

func begin_game():
	$MenuMusic.stop()
	$GameMusic.play()
	playing = true
	$Dayend.play()
	time = 0.0
	money = 0.0
	%Player.visible = true
	var world = $"../World"
	var statue = STATUE.instantiate()
	world.add_child(statue)
	statue.set_transform_(statue_spawn.global_transform) 
	%Money.visible = true
	%Money/Backdrop/quota.text = "$" + str(int(quota))
	%Player.process_mode = Node.PROCESS_MODE_INHERIT
	add_money(0)
	%InventoryDisplay.visible = true
	
func end_game():
	if not firsttime:
		$GameMusic.stop()
		$Dayend.play()
	$MenuMusic.play()
	for projectile in get_tree().get_nodes_in_group("Projectile"):
		projectile.queue_free()
	for coin in get_tree().get_nodes_in_group("Money"):
		coin.queue_free()
		
	playing = false
	inventory.total_money = int(money)
	inventory.rentals.clear()
	inventory.unlock_weapons(money)
	$"../World".process_mode = Node.PROCESS_MODE_DISABLED
	%Player.process_mode = Node.PROCESS_MODE_DISABLED
	$"../CanvasLayer/Menus/EndOfDay".visible = true
	$"../CanvasLayer/Menus/EndOfDay/Shop".setup()
	%Money.visible = false
	%InventoryDisplay.visible = false
	
func reset_game():
	
	for statue in get_tree().get_nodes_in_group("Statue"):
		statue.queue_free()
	$"../World".process_mode = Node.PROCESS_MODE_INHERIT
	$"../CanvasLayer/Menus/EndOfDay".visible = false
	if not firsttime:
		var rewind := Rewind.get_rewind(self)
		rewind.begin_rewind()
		rewind.rewind_finished.connect(begin_game, CONNECT_ONE_SHOT)
		%Player.visible = false
	else:
		firsttime = false
		begin_game()
	
	

func add_money(new):
	money += new
	%Money/Backdrop/earned.text = "$" + str(int(money))
	if new > 0:
		money_sounds.get_children().pick_random().play()
	
func _on_end_of_day_finished() -> void:
	reset_game()
