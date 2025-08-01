extends Node
class_name Rewind

signal time_updated(time: float)
signal rewind_finished()

const REWIND_DURATION = 3.0

var ghosts: Array[Ghost]

@onready var game_state = GameState.get_state(self)

var rewind_time := 0.0 
var rewind_t := 0.0 ## goes from 0 to REWIND_DURATION
var rewinding := false
var start_rewind_time := 0.0




func _process(delta: float) -> void:
	if not rewinding:
		if Input.is_action_just_pressed("DEBUG_rewind"):
			begin_rewind()
	
	if rewinding:
		rewind_t += delta * Hitstun.deltamod()
		rewind_time = lerp(start_rewind_time, 0.0, ease(rewind_t / REWIND_DURATION, Tween.EASE_IN_OUT))
		time_updated.emit(rewind_time)
		if rewind_t >= REWIND_DURATION:
			rewind_time = 0.0
			rewinding = false
			rewind_finished.emit()

func begin_rewind():
	rewinding = true
	start_rewind_time = game_state.time
	
func add_ghost(base: Sprite2D) -> Ghost:
	var ghost = Ghost.new()
	var sprite = Sprite2D.new()
	ghosts.append(ghost)
	ghost.sprite = sprite
	sprite.visible = false
	sprite.hframes = base.hframes
	sprite.vframes = base.vframes
	ghost.start_time = game_state.time if game_state else 0.0
	sprite.texture = base.texture.duplicate()
	add_child(sprite)
	time_updated.connect(ghost.on_time_updated)
	
	return ghost

static func get_rewind(node: Node) -> Rewind:
	return node.get_tree().get_first_node_in_group("Rewind") as Rewind

class Ghost:
	var sprite: Sprite2D
	var history: Array[PastState]
	var start_time: float = -100
	var end_time: float = 9999999
	func on_time_updated(time):
		
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
			sprite.global_rotation = past_state.rotation
			sprite.global_scale = past_state.scale
			

class PastState:
	var sprite_position := Vector2.ZERO
	var frame_coords := Vector2i.ZERO
	var sprite_texture: Texture = null
	var rotation := 0.0
	var scale := Vector2.ONE
	var visible: bool
	var time: float
	
	
