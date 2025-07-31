class_name GameState
extends Node

var time := 0.0
var money := 0.0
var quota := 1000.0


const DAY_LENGTH = 120

func _process(delta: float) -> void:
	time += delta / DAY_LENGTH
	
static func get_state(node: Node) -> GameState:
	return node.get_tree().get_first_node_in_group("GameState") as GameState
