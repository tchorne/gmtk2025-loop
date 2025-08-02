extends Node2D
@onready var continuous_damage: Node = $ContinuousDamage
@onready var inflictor: Node = $Inflictor

func set_active(a):
	continuous_damage.active = a
	
	var player_to_mouse = (get_viewport().get_camera_2d().get_global_mouse_position() - global_position).normalized()
	# set knockback
	inflictor.knockback = player_to_mouse * 30.0
	$Node/GPUParticles2D.emitting = a
	
func _physics_process(delta: float) -> void:
	if not continuous_damage.active: return
	for coin in get_tree().get_nodes_in_group("Money"):
		var c = coin as RigidBody2D
		c.apply_central_force(inflictor.knockback* 10.0)
	($Node/GPUParticles2D.process_material as ParticleProcessMaterial).direction = Vector3(inflictor.knockback.x, inflictor.knockback.y, 0).normalized()
