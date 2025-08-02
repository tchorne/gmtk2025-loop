extends RigidBody2D

@export_range(1, 1000, 1) var force := 1.0
@onready var inflicter: Node = $Inflicter

@export var sprites: Array[CompressedTexture2D]
@onready var sprite_2d: Sprite2D = $Sprite2D

var dead := false

var stuck_in_statue: Statue = null
var stuck_offset := Vector2.ZERO

func _ready():
	$Sprite2D.texture = sprites.pick_random()

func _physics_process(_delta: float) -> void:
	inflicter.knockback = linear_velocity * mass * force
	if is_instance_valid(stuck_in_statue):
		global_position = stuck_in_statue.global_position
		global_position += stuck_offset.rotated(stuck_in_statue.sprite_2d.rotation)
	else:
		freeze = false
	sprite_2d.global_rotation = linear_velocity.angle()
		
func on_hit(other: Statue):
	if not is_instance_valid(stuck_in_statue):
		stuck_in_statue = other
		stuck_offset = (other.global_position - global_position).rotated(-stuck_in_statue.sprite_2d.rotation) * 0.5
	call_deferred("after_hit")


func after_hit():
	freeze = true
	inflicter.enabled = false

func _on_bounce_detector_bounced() -> void:
	if not dead:
		dead = true
		gravity_scale = 1.0
