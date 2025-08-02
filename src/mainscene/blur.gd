extends ColorRect

const SHADER = preload("res://src/mainscene/shader.tres")

func _ready():
	get_viewport().size_changed.connect(resize)

func resize():
	var rad = get_window().size.y/1080.0 * 1.5
	SHADER.set_shader_parameter("radius", rad)
