extends Node

## Determines when a rigidbody has collided with a floor, wall, or ceiling

signal bounced

@export var rb: RigidBody2D

var prev_velocity := Vector2.RIGHT
var started := false


func _ready():
	prev_velocity = rb.linear_velocity.normalized()
	
func _physics_process(_delta: float) -> void:
	
	var dir1 = prev_velocity.normalized()
	var dir2 = rb.linear_velocity.normalized()
	
	if dir1.dot(dir2) <= 0.8 and started:
		bounced.emit()
		started = false
		$startup.start(0.1)
	
	prev_velocity = rb.linear_velocity
	


func _on_startup_timeout() -> void:
	started = true
