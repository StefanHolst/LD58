extends Control
@onready var quit_button: Button = $HBoxContainer/quit_button
@onready var restart_button: Button = $HBoxContainer/restart_button

func on_player_died():
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _ready() -> void:
	Resources.player_died.connect(on_player_died)
	quit_button.button_up.connect(on_quit_button_clicked)
	restart_button.button_up.connect(on_restart_button_clicked)

func on_quit_button_clicked() -> void:
	get_tree().quit()

func on_restart_button_clicked() -> void:
	Resources.restart_game()
	
