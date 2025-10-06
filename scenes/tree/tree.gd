class_name tree
extends RigidBody3D

func find_player() -> Node3D:
	for n in get_tree().get_nodes_in_group("player"):
		if n is Node3D:
			return n
	return

func _physics_process(dt: float) -> void:
	var player = find_player()
	if player != null:
		var new_target = Basis.looking_at(player.position - (position + Vector3(0, 2, 0)), Vector3.UP, true)
		basis = basis.slerp(new_target, 0.95 * dt)
