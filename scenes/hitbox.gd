extends Area3D
class_name HitBox

@export var damage: int = 1
@export var active: bool = false

@export var damage_over_time: bool = false
@export var damage_interval_sec: float = 1

@onready var last_damage: Timer = $DamageTimer

var take_damage: bool = false

func _on_body_entered(body: Node3D) -> void:
	if not active:
		return
	
	if body.is_in_group("player"):
		Resources.remove_pap(damage)
		if damage_over_time:
			take_damage = true
			last_damage.start(damage_interval_sec)
			last_damage.paused = false

func _on_body_exited(body: Node3D) -> void:
	if not active:
		take_damage = false
		return
	if body.is_in_group("player"):
		if last_damage:
			last_damage.stop()
		take_damage = false

func _on_damage_timer_timeout() -> void:
	if take_damage:
		Resources.remove_pap(damage)

func _ready():
	monitoring = true
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
