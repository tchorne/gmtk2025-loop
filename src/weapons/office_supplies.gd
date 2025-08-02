extends Node2D

@onready var projectile_emitter: Node = $ProjectileEmitter
@export var launch_speed := 200.0



func set_active(a: bool):
	projectile_emitter.active = a
	
func set_nearest_statue_vector(_vector: Vector2):
	#projectile_emitter.launch_velocity = vector * launch_speed
	projectile_emitter.launch_velocity = Vector2.RIGHT.rotated(global_rotation) * launch_speed

func _on_projectile_emitter_fired() -> void:
	$Throw.play()

func _process(_delta: float) -> void:
	projectile_emitter.launch_velocity = Vector2.RIGHT.rotated(global_rotation) * launch_speed
