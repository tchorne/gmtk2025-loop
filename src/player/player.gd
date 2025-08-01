extends CharacterBody2D

signal combo_dropped

const SPEED = 600.0
const JUMP_VELOCITY = -500.0
const BULLET = preload("res://src/weapons/Bullet.tscn")

const ACCELERATION = 1200.0
const AIR_ACCEL = 400.0
const DECCELERATION = 1800.0
const FRICTION = 800.0

@onready var melee: Node2D = $Melee
@onready var sounds: Node = $Sounds
@onready var player_sprite: Sprite2D = $SpriteScale/Sprite
@onready var stunned_1: Sprite2D = $SpriteScale/Sprite2D
@onready var stunned_2: Sprite2D = $SpriteScale/Sprite2D2

var move_time := 0.0 ## time spent moving in the same direction
var facing_right := true
var neutral_input := true ## true iff neither left nor right are held
var skidding
var crouching := false
var prev_ground := false

var stunned := 0
var stun_duration := 0.0

@onready var skid_particles: CPUParticles2D = $SkidParticles

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	neutral_input = true
	if direction < 0:
		neutral_input = false
	if direction > 0:
		neutral_input = false
		
		
	if not melee.in_attack and not Hitstun.paused:
		process_movement(delta * Hitstun.deltamod())

	
func process_movement(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * (1.0 if Input.is_action_pressed("up") else 1.5)
		if Input.is_action_pressed("down"):
			velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sounds.jump.play()
	
	if is_on_floor() and not prev_ground:
		# Landed
		sounds.land.play()
		
	var prev_skidding = skidding
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
					if not prev_skidding:
						sounds.skid.play()
				velocity.x += direction * FRICTION * delta
			velocity.x += direction * (ACCELERATION if is_on_floor() else AIR_ACCEL)  * delta
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	
	skid_particles.emitting = skidding
	skid_particles.direction.x = sign(velocity.x)
	prev_ground = is_on_floor()
	
	move_and_slide()
	
func _process(_delta: float) -> void:
	pass

func _on_melee_attack_dropped() -> void:
	combo_dropped.emit()


func _on_melee_attack_ended() -> void:
	combo_dropped.emit()


func _on_statue_hitter_area_entered(area: Area2D) -> void:
	# Hit by a statue
	var statue = area.get_statue() as Statue
	
	if statue.rigid_body.linear_velocity.length() > 400 and statue.damaging:
		onhit()

func onhit():
	sounds.whomp.play()
