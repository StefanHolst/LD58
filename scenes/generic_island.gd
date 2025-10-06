extends Node3D

@export var sink_rate: float = 0.2

@onready var Hitbox: Area3D = $Hitbox

var is_sinking: bool = false

func _ready() -> void:
	Hitbox.connect("body_entered", _on_body_entered)
	Hitbox.connect("body_exited", _on_body_exited)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_sinking = true

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_sinking = false

func _process(delta: float) -> void:
	if is_sinking:
		global_position.y -= sink_rate * delta
