class_name PoopKo
extends RigidBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pop_spawn: Node3D = $Pop_spawn
@export var pop_scene: PackedScene
@export var poop_speed: float = 30
@export var attack_distance: float = 30
var attack_dir: Vector3 = Vector3(0, 0, 0)

func compute_attack_vector() -> void:
	var player = find_player()
	if player == null:
		attack_dir = Vector3(0, 0, 0)
	
	attack_dir = pop_spawn.global_position.direction_to(player.global_position)

func distance_to_player() -> float:
	var player = find_player()
	if player == null:
		return INF
	
	return player.global_position.distance_to(global_position)

func fire_poop() -> void:
	var poop = pop_scene.instantiate()
	if poop is RigidBody3D:
		poop.global_position = pop_spawn.global_position
		poop.linear_velocity = attack_dir * poop_speed
		poop.freeze = false
	get_tree().root.get_child(1).add_child(poop)

func find_player() -> Node3D:
	for n in get_tree().get_nodes_in_group("player"):
		if n is Node3D:
			return n
	return

func look_at_player(dt: float) -> void:
	var player = find_player()
	if player != null:
		var target_vector = player.global_position - (global_position)
		var new_target = Basis.looking_at(target_vector, Vector3.UP, true)
		var new_rotation = new_target.get_rotation_quaternion().get_euler() 
		global_rotation = global_rotation.slerp(new_rotation, 0.95 * dt)

func _process(dt: float) -> void:
	look_at_player(dt)
	if distance_to_player() <= attack_distance and not animation_player.is_playing():
		animation_player.play("fire")

func get_value() -> int:
	return 40
