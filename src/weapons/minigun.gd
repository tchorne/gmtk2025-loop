extends Node2D

@onready var projectile_emitter: Node = $ProjectileEmitter
@export var launch_speed := 300.0
@onready var pivot: Node2D = $Pivot



func set_active(a: bool):
	projectile_emitter.active = a
	$Gun.stream_paused = not a
	
func set_nearest_statue_vector(vector: Vector2):
	#projectile_emitter.launch_velocity = vector * launch_speed
	projectile_emitter.launch_velocity = Vector2.RIGHT.rotated(global_rotation) * launch_speed

func _on_projectile_emitter_fired() -> void:
	pivot.rotation = randf_range(TAU/12, -TAU/12)

func _process(delta: float) -> void:
	pivot.rotation = move_toward(pivot.rotation, 0, TAU * delta * Hitstun.deltamod())
	projectile_emitter.launch_velocity = Vector2.RIGHT.rotated(global_rotation) * launch_speed
	
