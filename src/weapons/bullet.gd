extends RigidBody2D

@export_range(1, 1000, 1) var force := 1.0
@onready var inflicter: Node = $Inflicter

var dead := false

func _process(delta: float) -> void:
	inflicter.knockback = linear_velocity * mass * force

func on_hit(other: Statue):
	queue_free()


func _on_bounce_detector_bounced() -> void:
	if not dead:
		dead = true
		gravity_scale = 1.0
