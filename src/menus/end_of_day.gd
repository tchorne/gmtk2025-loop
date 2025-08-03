extends Control

signal finished



func _on_time_travel_pressed() -> void:
	## TODO confirmation
	finished.emit()
	


func _on_freeplay_pressed() -> void:
	GameState.get_state(self).freeplay = true
	$Results.visible = false
	

func _on_reset_pressed() -> void:
	GameState.get_state(self).reset_all()
