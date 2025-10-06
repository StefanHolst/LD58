extends Area3D

@onready var active: bool = true

func _on_body_entered(body: Node3D) -> void:
	if not active:
		return
		
	if body is PlayerBody:
		Resources.win_game()
		active = false
