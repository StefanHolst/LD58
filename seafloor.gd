extends StaticBody3D

@export var player: Node3D

func _process(_delta: float) -> void:
	var p = player.global_position
	global_position = Vector3(p.x, global_position.y, p.z)
