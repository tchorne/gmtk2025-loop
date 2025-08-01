extends Node

@export var cursor_1 : CompressedTexture2D
@export var cursor_2 : CompressedTexture2D


func _ready():
	DisplayServer.cursor_set_custom_image(cursor_1.get_image(), DisplayServer.CURSOR_ARROW, Vector2(22,6))
	DisplayServer.cursor_set_custom_image(cursor_2.get_image(), DisplayServer.CURSOR_POINTING_HAND, Vector2(22,8))
	


func clickable_hovered():
	DisplayServer.cursor_set_shape(DisplayServer.CURSOR_POINTING_HAND)

func clickable_unhovered():
	DisplayServer.cursor_set_shape(DisplayServer.CURSOR_ARROW)
