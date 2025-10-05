extends Node3D

func find_player() -> Node3D:
	for n in get_tree().get_nodes_in_group("player"):
		if n is Node3D:
			return n
	return

func _process(dt: float) -> void:
	var player = find_player()
	if player != null:
		look_at(player.position, Vector3.UP, true)
