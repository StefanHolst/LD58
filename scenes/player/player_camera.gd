extends Camera3D
class_name PlayerCamera

@export var shake_duration: float = 0.5
@export var shake_magnitude: float = 0.75
@export var shake_frequency: float = 40.0

@onready var shake_timer: float = 0.0

func _process(dt: float) -> void:
	shake_timer = max(0.0, shake_timer - dt)
	position.x = sin(shake_timer * shake_frequency) * shake_magnitude * shake_timer

func shake() -> void:
	shake_timer = shake_duration
