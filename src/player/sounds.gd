extends Node

@export_range(0 ,1 ,0.1 ) var run_volume

@onready var run: AudioStreamPlayer = $Run
@onready var skid: AudioStreamPlayer = $Skid
@onready var land: AudioStreamPlayer = $Land
@onready var jump: AudioStreamPlayer = $Jump
@onready var whomp: AudioStreamPlayer = $Whomp
@onready var ding: AudioStreamPlayer = $Ding

func _process(_delta: float) -> void:
	run.volume_db = linear_to_db(run_volume)
