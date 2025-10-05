extends Node3D

@export var projectile_scene: PackedScene
var fire_rate: float = 1
var _last_shot: float = 0
var _can_shoot = true
var _trigger_released = true

func _physics_process(delta: float) -> void:
	_last_shot += delta
	if _last_shot > fire_rate:
		_can_shoot = true
		_last_shot = 0

func trigger():
	if _can_shoot && _trigger_released:
		_trigger_released = false
		_can_shoot = false
		var projectile = projectile_scene.instantiate()
		get_tree().current_scene.add_child(projectile)
		projectile.spawn(global_position, -global_transform.basis.z)

func release():
	_trigger_released = true
