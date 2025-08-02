extends Node

## Creates some number of projectiles per second

signal fired

@export var rate: float
@export var launch_velocity: Vector2
@export var projectile: PackedScene
@export var parent: Node
@export var active := false
@export var spawn_point: Node2D
@export var randomness := 0.0

var time_to_fire := 0.0

func _process(delta: float):
	if active:
		time_to_fire -= delta * Hitstun.deltamod()
		while (time_to_fire < 0.0):
			time_to_fire += 1.0 / rate
			fire()

func fire():
	var p : RigidBody2D = projectile.instantiate() as RigidBody2D
	parent.add_child(p)
	p.global_position = spawn_point.global_position
	var vel = launch_velocity.rotated(randf_range(-randomness, randomness))
	p.rotation = vel.angle()
	p.linear_velocity = vel
	fired.emit()
	
	
