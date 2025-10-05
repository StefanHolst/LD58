extends Node3D

@export var speed: float = 50
@export var damage: float = 1
var lifetime: float = 1
var velocity: Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	# Check if projectile has outlived its life
	lifetime -= delta
	if lifetime < 0:
		queue_free()
	
	# move projectile
	global_position += velocity * delta

func spawn(pos: Vector3, dir: Vector3):
	global_position = pos
	dir = dir.normalized()
	velocity = dir * speed
	
	look_at(pos + dir, Vector3.UP, true)
	
	set_physics_process(true)
