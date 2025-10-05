extends Area3D
class_name HitBox

@export var damage: int = 1
@export var active: bool = false

func _on_body_entered(body: Node3D) -> void:
	if not active:
		return

	if body.is_in_group("player"):
		Resources.remove_pap(damage)

func _ready():
	monitoring = true
	body_entered.connect(_on_body_entered)
