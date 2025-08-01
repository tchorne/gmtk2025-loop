extends Node

var paused = false
var gamespeed = 1.0

var hitstun_remaining = 0.0

func extend_hitstun(amount: float):
	hitstun_remaining = max(hitstun_remaining, amount)
	paused = true

func _process(delta: float) -> void:
	hitstun_remaining -= delta
	if hitstun_remaining < 0:
		paused = false

func deltamod() -> float:
	if paused: return 0
	return gamespeed
	
