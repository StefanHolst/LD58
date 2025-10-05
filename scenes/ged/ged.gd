extends RigidBody3D

@export var max_search_distance: float = 100
@export var attack_distance: float = 20
@export var move_force: float = 10
@export var attack_force: float = 30

@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var attack_target: Node3D = null
@onready var attack_force_dir: Vector3 = Vector3(0, 0, 0)

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
	
	var n = (player.position - position)
	var d = n.length()
	if d < attack_distance:
		animation_player.play("attack")
		attack_force_dir = n / d
		attack_target = player
		set_process(false)
		await animation_player.animation_finished
		set_process(true)
	else:
		apply_impulse(n * move_force / d)

func compute_attack_dir() -> void:
	attack_force_dir = -attack_target.position.direction_to(position)

func attack_player() -> void:
	var n = attack_force_dir
	var d = n.length()
	apply_impulse(n * attack_force / d)
	
	
