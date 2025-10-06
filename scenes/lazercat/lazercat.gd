extends Node3D
@onready var lazer: Lazer = $Lazer
@onready var lazer_2: Lazer = $Lazer2

@export var aggro_range: float = 74

func find_player() -> Node3D:
	for n in get_tree().get_nodes_in_group("player"):
		if n is Node3D:
			return n
	return

func look_at_player(dt: float) -> void:
	var player = find_player()
	if player is Node3D:
		if player.global_position.distance_to(global_position) <= aggro_range:	
			lazer.aim(player.global_position, dt)
			lazer_2.aim(player.global_position, dt)
		else:
			lazer.aim(Vector3(0, 0, 0), dt)
			lazer_2.aim(Vector3(0, 0, 0), dt)

func _physics_process(dt: float) -> void:
	look_at_player(dt)
