extends Area3D
class_name ShipDetector

@onready var player_body: PlayerBody = $".."

func _process(delta: float) -> void:
	if not Input.is_action_just_pressed("ship_mode"):
		return
	
	var bodies = get_overlapping_bodies()
	for b in bodies:
		if b is Boat:
			b.active = true
			player_body.active = false
			player_body.reparent(b)
