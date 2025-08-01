extends Area2D

## A type of area that is detected by the statue

signal hit_statue(statue: Statue)

func on_hit(other: Statue):
	hit_statue.emit(other)
