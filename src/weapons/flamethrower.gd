extends Node2D

@onready var continuous_damage: Node = $ContinuousDamage

var active := false
var prev_active := false

var bigger_gun := true

func _ready():
	Perks.perk_acquired.connect(perkitup)

func perkitup(x):
	if x == Perks.IMPROVED_NOZZLE and not bigger_gun:
		$Pivot.apply_scale(1.3)
		bigger_gun = true
		
func set_active(a):
	continuous_damage.active = a
	
	active = a

func _process(_delta: float) -> void:
	if active and not prev_active:
		$FlamethrowerStart.play()
		$Flamethrower1.play()
		
	if not active:
		$FlamethrowerStart.play()
		$Flamethrower1.stop()
		
	prev_active = active
