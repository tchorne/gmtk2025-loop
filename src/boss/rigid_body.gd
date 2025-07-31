extends Area2D

const Statue = preload("res://src/boss/statue.gd")

func get_statue() -> Statue:
	return $".."
