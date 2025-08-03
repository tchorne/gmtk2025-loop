extends Control

func _ready() -> void:
	Dialogic.start("timeline")
	Dialogic.timeline_ended.connect(next)

func next():
	get_tree().change_scene_to_file("res://src/mainscene/main.tscn")


func _on_button_pressed() -> void:
	Dialogic.end_timeline()
	
