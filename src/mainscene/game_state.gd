class_name GameState
extends Node

signal reload_perks
signal begin_day
signal freeplay_started

const STATUE = preload("res://src/boss/statue.tscn")
const DAY_LENGTH = 40.5

var day_number := -1
var time := 0.0
var total_earnings := 0.0
var money := 0.0
var quota := 99.0
var quota_mod := 1.2
var eval_day := 6
var playing := false
var firsttime := true
var income_mult := 1.0
var freeplay := false :
	set(new):
		freeplay = new
		if new:
			freeplay_started.emit()
var failed_quota := false
var earnings_history = []

@onready var player_position: Vector2 = $"../World/Player".global_position
@onready var statue_spawn: Marker2D = %StatueSpawn
@onready var money_sounds: Node = $MoneySounds
@onready var inventory := Inventory.get_inventory(self)

func _ready():
	#begin_game()
	
	get_tree().process_frame.connect(func():
		money = 45
		end_game()
	, CONNECT_ONE_SHOT
	)
	
func _process(delta: float) -> void:
	if playing:
		time += delta / DAY_LENGTH
		inventory.update_rentals(time)
	if time >= 1.0 and playing:
		end_game()
	
static func get_state(node: Node) -> GameState:
	return node.get_tree().get_first_node_in_group("GameState") as GameState

func begin_game():
	begin_day.emit()
	
	day_number+=1
		
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
	money = money * income_mult
	total_earnings += money
	$MenuMusic.play()
	for projectile in get_tree().get_nodes_in_group("Projectile"):
		projectile.queue_free()
	for coin in get_tree().get_nodes_in_group("Money"):
		coin.queue_free()
	
	reload_perks.emit()
	playing = false
	
	failed_quota = money < quota
	
	
	if not firsttime:
		$GameMusic.stop()
		$Dayend.play()
		quota_mod = 1.2
	earnings_history.append(int(money))
	inventory.total_money = int(money)
	inventory.clear_rentals()
	inventory.unlock_weapons(money)
	$"../World".process_mode = Node.PROCESS_MODE_DISABLED
	%Player.process_mode = Node.PROCESS_MODE_DISABLED
	$"../CanvasLayer/Menus/EndOfDay".visible = true
	var performance = eval_day == day_number
	$"../CanvasLayer/Menus/EndOfDay/Shop".setup(failed_quota, performance, firsttime)
	%Money.visible = false
	%InventoryDisplay.visible = false
	
func reset_game():
	if not failed_quota:
		quota = quota * quota_mod
	for statue in get_tree().get_nodes_in_group("Statue"):
		statue.queue_free()
	$"../World".process_mode = Node.PROCESS_MODE_INHERIT
	$"../CanvasLayer/Menus/EndOfDay".visible = false
	if not firsttime:
		var rewind := Rewind.get_rewind(self)
		rewind.begin_rewind()
		rewind.rewind_finished.connect(begin_game, CONNECT_ONE_SHOT)
		%Player.visible = false
		$Bellbig.play()
	else:
		firsttime = false
		begin_game()
	$"../CanvasLayer/ScheduleDisplay".set_rentals()

func get_quota():
	return quota * quota_mod

func add_money(new):
	
	money += new
	%Money/Backdrop/earned.text = "$" + str(int(money * income_mult))
	var c = Color(0.0, 0.494, 0.048) if (money * income_mult >= quota) else Color(0.582, 0.184, 0.148)
	%Money/Backdrop/earned.add_theme_color_override("font_color", c)
	
	%Money/Backdrop/earned/AnimatedSprite2D.modulate = c
	%Money/Backdrop/earned/AnimatedSprite2D.visible = (money * income_mult  < quota)
	
	if new > 0:
		money_sounds.get_children().pick_random().play()

func _on_end_of_day_finished() -> void:
	reset_game()

func reset_all():
	Perks.owned_perks.clear()
	get_tree().reload_current_scene()
