extends Camera2D

func _process(_delta: float) -> void:
	zoom = Vector2.ONE * get_viewport_rect().size.x / 1152.0
