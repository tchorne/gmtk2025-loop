extends CharacterBody2D

signal combo_dropped

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const BULLET = preload("res://src/weapons/Bullet.tscn")

const ACCELERATION = 600.0
const AIR_ACCEL = 200.0
const DECCELERATION = 1000.0
const FRICTION = 400.0

@onready var melee: Node2D = $Melee

var move_time := 0.0 ## time spent moving in the same direction
var facing_right := true
var neutral_input := true ## true iff neither left nor right are held
var skidding
var crouching := false

@onready var skid_particles: CPUParticles2D = $SkidParticles

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	neutral_input = true
	if direction < 0:
		facing_right = false
		neutral_input = false
	if direction > 0:
		facing_right = true
		neutral_input = false
		
		
	if not melee.in_attack:
		process_movement(delta * Hitstun.deltamod())

	
func process_movement(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	skidding = false
	
	var direction := Input.get_axis("left", "right")
	var crouch := Input.is_action_pressed("down")
	
	crouching = is_on_floor() and abs(velocity.x) < 0.2 and crouch
	
	if sign(direction) == sign(velocity.x):
		move_time += delta
	else:
		move_time = 0.0
	
	if direction and not crouching:
		var increase_topspeed = (abs(velocity.x) > SPEED and sign(velocity.x) == sign(direction))
		if (!increase_topspeed):
			if (sign(velocity.x) * sign(direction) < 0):
				if (is_on_floor()):
					skidding = true
				velocity.x += direction * FRICTION * delta
			velocity.x += direction * (ACCELERATION if is_on_floor() else AIR_ACCEL)  * delta
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	
	skid_particles.emitting = skidding
	skid_particles.direction.x = sign(velocity.x)
	move_and_slide()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("medatk"):
		var bullet = BULLET.instantiate()
		get_parent().add_child(bullet)
		var to_mouse = get_viewport().get_camera_2d().get_global_mouse_position() - global_position
		
		to_mouse = to_mouse.normalized()
		bullet.velocity = to_mouse * 5
		bullet.global_position = global_position


func _on_melee_attack_dropped() -> void:
	combo_dropped.emit()


func _on_melee_attack_ended() -> void:
	combo_dropped.emit()
