extends Node
class_name Rewind

var ghosts: Array[Ghost]

@onready var game_state = GameState.get_state(self)

func _process(delta: float) -> void:
	pass
	
func add_ghost(base: Sprite2D) -> Ghost:
	var ghost = Ghost.new()
	var sprite = Sprite2D.new()
	sprite.visible = false
	sprite.texture = base.texture.duplicate()
	add_child(sprite)
	
	return ghost

static func get_rewind(node: Node) -> Rewind:
	return node.get_tree().get_first_node_in_group("Rewind") as Rewind

class Ghost:
	var sprite: Sprite2D
	var history: Array[PastState]
	var start_time: float = -100
	var end_time: float = 9999999
	func time_updated(time):
		
		if time < start_time or time > end_time:
			sprite.visible = false
			return
			
		while not history.is_empty() and history.back().time > time:
			var past_state := history.pop_back() as PastState
			sprite.global_position = past_state.sprite_position
			if past_state.sprite_texture != null:
				sprite.texture = past_state.sprite_texture
			sprite.frame_coords = past_state.frame_coords
			sprite.visible = past_state.visible
			

class PastState:
	var sprite_position := Vector2.ZERO
	var frame_coords := Vector2i.ZERO
	var sprite_texture: Texture = null
	var visible: bool
	var time: float
	
	
