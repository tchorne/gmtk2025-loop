extends RigidBody2D

signal statue_hit(statue: Statue)

const RELEASE_VELOCITY = 750.0

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
	sprite_2d.global_rotation = linear_velocity.angle() - TAU/4
		
func on_hit(other: Statue):
	if not is_instance_valid(stuck_in_statue) and not dead:
		stuck_in_statue = other
		stuck_offset = (other.global_position - global_position).rotated(-stuck_in_statue.sprite_2d.rotation) * 0.5
		statue_hit.emit(other)
	if not dead:
		call_deferred("after_hit")


func after_hit():
	freeze = true
	inflicter.enabled = false

func _on_bounce_detector_bounced() -> void:
	if not dead:
		dead = true
		gravity_scale = 1.0

func release():
	freeze = false
	linear_velocity = RELEASE_VELOCITY * Vector2.RIGHT.rotated(randf()*TAU)
	stuck_in_statue = null
	$Intangible.start(0.4)
	

func _on_intangible_timeout() -> void:
	inflicter.enabled = true
	dead = false
	
func apply_wind(force: Vector2):
	pass
	
