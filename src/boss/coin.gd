extends RigidBody2D

enum {
	TYPE_COIN,
	TYPE_BILL
}

var my_type: int
var dying := false
var time_remaining := 1.0
var value := 0
#@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

@export var bill_colors: Array[Color]
@onready var game_state := GameState.get_state(self)

func _on_collect_body_entered(_body: Node2D) -> void:
	if dying: return
	dying = true
	#gpu_particles_2d.restart()
	$Coin.visible = false
	$Bill.visible = false
	game_state.add_money(value)
	
func _process(delta: float) -> void:
	set_physics_process(Hitstun.paused)
	if dying:
		time_remaining -= delta * Hitstun.deltamod()
		if time_remaining < 0:
			queue_free()
	if sleeping:
		$Bill.frame = 0
			
func _ready() -> void:
	linear_velocity = Vector2.RIGHT.rotated(randf()*TAU) * 200
	

func set_value(ivalue): ## 1, 2, 5, 10, 20, 50, 100
	value = ivalue
	var color = [1,2,5,10,20,50,100].find(value)
	if color <= 1:
		my_type = TYPE_COIN
	else:
		my_type = TYPE_BILL
		
	if my_type == TYPE_BILL:
		gravity_scale = 0.1
		$Bill.modulate = bill_colors[color-2]
		$Bill.visible = true
		$Bill.frame = 1
	else:
		$Coin.visible = true
		if color == 1:
			$Coin.apply_scale(Vector2.ONE * 1.5)
		
func _on_timer_timeout() -> void:
	var coin : Sprite2D = $Coin
	
	var frame = coin.frame
	if coin.flip_h:
		frame += 1
		if frame >= 2:
			coin.flip_h = false
	else:
		frame -= 1
		if frame <= 0:
			coin.flip_h = true
	coin.frame = clamp(frame, 0, 2)
