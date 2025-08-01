extends RigidBody2D

enum {
	TYPE_COIN,
	TYPE_BILL
}

var my_type: int
var dying := false
var time_remaining := 1.0
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D


func _on_collect_body_entered(_body: Node2D) -> void:
	if dying: return
	dying = true
	audio_stream_player.play()
	gpu_particles_2d.restart()
	$Coin.visible = false
	$Bill.visible = false
	
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
	my_type = randi()%2
	if my_type == TYPE_BILL:
		gravity_scale = 0.1
		$Bill.visible = true
		$Bill.frame = 1
	else:
		$Coin.visible = true


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
