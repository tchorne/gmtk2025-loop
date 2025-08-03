extends TextureButton

@export var timeline_label := ""

func _on_pressed() -> void:
	Dialogic.start("tutorials", timeline_label)
