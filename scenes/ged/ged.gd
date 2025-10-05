extends RigidBody3D

@export var max_search_distance: float = 100
@export var move_force: float = 10

@onready var timer: Timer = $Timer

func _search_for_player() -> Node3D:
	var d_max_sq = max_search_distance * max_search_distance
	var players = get_tree().get_nodes_in_group("player")
	for p in players:
		if p is Node3D:
			var d = p.position.distance_squared_to(position)
			if d <= d_max_sq:
				return p
	
	return

func _process(delta: float) -> void:
	if not timer.is_stopped():
		return
		
	timer.start()
	var player = _search_for_player()
	if player == null:
		return
	
	var n = (player.position - position).normalized()
	apply_impulse(n * move_force)
		
		
