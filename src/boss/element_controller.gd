extends Control

var element_amounts: Dictionary[Element.Element, float]
var element_icons: Dictionary[Element.Element, Control]

const ELEMENT_ICON = preload("res://src/boss/element_icon.tscn")

@onready var node_2d: Node2D = $".."
@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var sprite_2d: Sprite2D = %Sprite2D

func add_element(element: Element.Element, amount := 1.0):
	if element == Element.Element.NONE: return
	element_amounts[element] += amount



func _ready():
	for element in Element.Element.size():
		element_amounts[element] = 0
		if element == Element.Element.NONE: continue
		var icon = ELEMENT_ICON.instantiate()
		icon.visible = false
		v_box_container.add_child(icon)
		element_icons[element] = icon
		
func _process(delta: float) -> void:
	node_2d.global_position = sprite_2d.global_position
	for element in Element.Element.size():
		if element == Element.Element.NONE: continue
		var amount = element_amounts[element]
		amount -= delta * Hitstun.deltamod()
		element_amounts[element] = clamp(amount, 0, 15)
		if element < Element.Element.HOOKED:
			element_icons[element].visible = amount > 0
			element_icons[element].get_node("Sprite2D").frame = element-1
