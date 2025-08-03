extends Control

const BUS_LAYOUT = preload("res://src/mainscene/bus_layout.tres")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_visible()

func toggle_visible():
	visible = not visible

func _on_reset_pressed() -> void:
	GameState.get_state(self).reset_all()


func _on_blur_pressed() -> void:
	var mat = (get_tree().get_first_node_in_group("ScreenShader").material as ShaderMaterial)
	mat.set_shader_parameter("blur", not mat.get_shader_parameter("blur"))



func _on_grain_pressed() -> void:
	var mat = (get_tree().get_first_node_in_group("ScreenShader").material as ShaderMaterial)
	mat.set_shader_parameter("grain", not mat.get_shader_parameter("grain"))


func _on_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, linear_to_db(value))


func _on_sound_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, linear_to_db(value))


func _on_close_pressed() -> void:
	visible = false
