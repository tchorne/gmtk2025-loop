extends RigidBody2D

var dying := false
var time_remaining := 1.0
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

func _on_collect_body_entered(_body: Node2D) -> void:
	if dying: return
	dying = true
	audio_stream_player.play()
	gpu_particles_2d.restart()
	$Sprite2D.visible = false
	
func _process(delta: float) -> void:
	if dying:
		time_remaining -= delta
		if time_remaining < 0:
			queue_free()

func _ready() -> void:
	linear_velocity = Vector2.RIGHT.rotated(randf()*TAU) * 200
