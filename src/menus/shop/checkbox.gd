extends TextureButton

@onready var checkmark = $TextureRect


func _ready():
	toggle_mode = true
	pressed.connect(_on_pressed)
	checkmark.visible = button_pressed
	
func _on_pressed() -> void:
	checkmark.visible = button_pressed
