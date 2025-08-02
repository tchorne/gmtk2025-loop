extends Control

signal finished



func _on_time_travel_pressed() -> void:
	## TODO confirmation
	finished.emit()
	
