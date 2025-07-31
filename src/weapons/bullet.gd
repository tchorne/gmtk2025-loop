extends Area2D

const Statue = preload("res://src/boss/statue.gd")

@export_range(1, 1000, 1) var force := 1.0

var velocity := Vector2.ZERO

func _process(_delta: float) -> void:
	position += velocity

func on_hit(other: Statue):
	other.add_knockback(force * velocity.normalized())
	other.take_damage()
	queue_free()
