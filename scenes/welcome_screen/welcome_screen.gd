extends CenterContainer

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$Panel/VBoxContainer/Button.pressed.connect(_on_button_pressed)
	$Panel/VBoxContainer/Button2.pressed.connect(_on_button2_pressed)

func _on_button_pressed():
	print("go go go")
	get_tree().change_scene_to_file("res://main.tscn")

func _on_button2_pressed():
	get_tree().quit()
