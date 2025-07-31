@tool
extends Node

enum AnimState {
	DEFAULT,
	CROUCH,
	RUN,
	JUMP_UP,
	JUMP_DOWN,
	SKID
}
const DEFAULT_SCALE = Vector2(0.1, 0.1)

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var sprite: Sprite2D = $"../SpriteScale/Sprite"
@onready var sprite_scale: Node2D = $"../SpriteScale"

@onready var animation_tree: AnimationTree = $"../AnimationTree"
@onready var player: CharacterBody2D = $".."
@onready var state_machine = animation_tree["parameters/playback"]

var current_state: AnimState = AnimState.DEFAULT

@export_range(0.5, 2.0, 0.05) var squish_vertical: float = 1.0


var squish_vertical_2: float = 1.0


func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	animation_player.speed_scale = 1.0
	squish_vertical_2 = 1
	if player.is_on_floor():
		if (player.skidding):
			switch_to(AnimState.SKID)
		elif (player.crouching):
			switch_to(AnimState.CROUCH)
		elif abs(player.velocity.x) < 0.1 and player.neutral_input:
			switch_to(AnimState.DEFAULT)
		else:
			switch_to(AnimState.RUN)
			animation_player.speed_scale = player.velocity.x / player.SPEED
	else:
		squish_vertical_2 = lerp(1.0, 0.8, clamp(abs(player.velocity.y)/1000, 0, 1))
		if player.velocity.y < 0:
			switch_to(AnimState.JUMP_UP)
		else:
			switch_to(AnimState.JUMP_DOWN)
	sprite.flip_h = not player.velocity.x > 0
	
	sprite_scale.scale.y = DEFAULT_SCALE.y / squish_vertical / squish_vertical_2
	sprite_scale.scale.x = DEFAULT_SCALE.x * squish_vertical * squish_vertical_2
	
func switch_to(new_state: AnimState):
	var state_string = "default" 
	match(new_state):
		AnimState.DEFAULT:
			state_string = "default"
		AnimState.RUN:
			state_string = "run"
		AnimState.CROUCH:
			state_string = "crouch"
		AnimState.JUMP_UP:
			state_string = "rise"
		AnimState.JUMP_DOWN:
			state_string = "fall"
		AnimState.SKID:
			state_string = "skid"
			
	current_state = new_state
	state_machine.travel(state_string)
	
