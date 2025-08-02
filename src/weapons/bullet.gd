extends RigidBody2D

@export_range(1, 1000, 1) var force := 1.0
@onready var inflicter: Node = $Inflicter
@onready var sprite_2d: Sprite2D = $Sprite2D

var dead := false

func _process(_delta: float) -> void:
	inflicter.knockback = linear_velocity * mass * force
	sprite_2d.global_rotation = linear_velocity.angle()

func on_hit(_other: Statue):
	queue_free()


func _on_bounce_detector_bounced() -> void:
	if not dead:
		dead = true
		gravity_scale = 1.0
