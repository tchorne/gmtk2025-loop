class_name GameState
extends Node

const STATUE = preload("res://src/boss/statue.tscn")
const DAY_LENGTH = 60

var time := 0.0
var money := 0.0
var quota := 1000.0
var playing := false

@onready var player_position: Vector2 = $"../World/Player".global_position
@onready var statue_spawn: Marker2D = %StatueSpawn

func _ready():
	begin_game()

func _process(delta: float) -> void:
	if playing:
		time += delta * Hitstun.deltamod() / DAY_LENGTH
	if time >= 1.0 and playing:
		end_game()
	
static func get_state(node: Node) -> GameState:
	return node.get_tree().get_first_node_in_group("GameState") as GameState

func begin_game():
	playing = true
	$Dayend.play()
	time = 0.0
	money = 0.0
	%Player.visible = true
	var world = $"../World"
	var statue = STATUE.instantiate()
	world.add_child(statue)
	statue.set_transform_(statue_spawn.global_transform) 

func end_game():
	playing = false
	$Dayend.play()

func reset_game():
	for statue in get_tree().get_nodes_in_group("Statue"):
		statue.queue_free()
	var rewind := Rewind.get_rewind(self)
	rewind.begin_rewind()
	rewind.rewind_finished.connect(begin_game, CONNECT_ONE_SHOT)
	%Player.visible = false
