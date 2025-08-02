extends Node

signal selected(menutab: Node)

@onready var control: Control = get_parent()
@onready var default_position = control.position.y

@export var base_height := 0.0
@export var hover_height := 10.0
@export var select_height := 200.0

var active := false

func _ready():
	control.gui_input.connect(on_parent_input)
	control.mouse_entered.connect(hover)
	control.mouse_exited.connect(unhover)
	
func on_parent_input(input: InputEvent):
	if input is InputEventMouseButton and input.button_index == MOUSE_BUTTON_LEFT and input.is_pressed():
		select()

func select(): ## clicked on
	if active: return
	active = true
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(control, "position:y", select_height, 0.5)
	selected.emit(self)

func deselect(): ## clicked on bkg or specific close button
	
	if not active: return
	active = false
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(control, "position:y", base_height, 0.5)

func unhover():
	if active:
		return
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(control, "position:y", base_height, 0.2)
	
func hover():
	if active:
		return
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(control, "position:y", hover_height, 0.2)


func _on_catalogue_gui_input(event: InputEvent) -> void:
	pass
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		#deselect()
