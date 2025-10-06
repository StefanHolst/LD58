extends Control

func on_player_died():
	visible = true

func _ready() -> void:
	Resources.player_died.connect(on_player_died)
