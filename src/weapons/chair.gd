extends Node2D

@onready var instant_damage: Node = $InstantDamage

@export var cooldown: float
@onready var timer: Timer = $Timer
@onready var go_away: Timer = $Timer2
var cpu_particles_2d: CPUParticles2D

var active := false

func _ready():
	if has_node("Area2D/CPUParticles2D"):
		cpu_particles_2d = get_node("Area2D/CPUParticles2D")

func set_active(a: bool):
	if a:
		if cpu_particles_2d: cpu_particles_2d.emitting = true
		active = true
		get_parent().get_parent().cooldown = cooldown
		timer.start(0.1)
		go_away.start(cooldown)
	
	if active:
		visible = true


func _on_timer_timeout() -> void:
	instant_damage.trigger_hit()

func _on_timer_2_timeout() -> void:
	if cpu_particles_2d: cpu_particles_2d.emitting = false
	active = false
