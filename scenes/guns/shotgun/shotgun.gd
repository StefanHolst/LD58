extends Node3D

@export var projectile_scene: PackedScene
var pellets: int = 5
var spread: float = 0.052
var fire_rate: float = 1
var _last_shot: float = 0
var _can_shoot = true
var _trigger_released = true

func _ready() -> void:
	Resources.pap.connect(Callable(self, "_update"))

func _update():
	pellets = 5
	if Resources.shotgun_upgrades & 1 != 0:
		pellets = 10
	spread = 0.087
	if Resources.shotgun_upgrades & 2 != 0:
		spread = 0.052
	fire_rate = 1
	if Resources.shotgun_upgrades & 4 != 0:
		fire_rate /= 2

func _input(event: InputEvent) -> void:
	if (Resources.leftHand and Resources.leftHand.get_parent() == self) or (Resources.rightHand and Resources.rightHand.get_parent() == self):
		if event is InputEventKey and event.keycode == KEY_F:
			if event.pressed:
				trigger()
			else:
				release()

func _physics_process(delta: float) -> void:
	_last_shot += delta
	if _last_shot > fire_rate:
		_can_shoot = true
		_last_shot = 0

func trigger():
	if _can_shoot and _trigger_released and Resources.papCounter >= pellets:
		_trigger_released = false
		_can_shoot = false
		
		Resources.remove_pap(pellets)
		for i in pellets:
			var projectile = projectile_scene.instantiate()
			get_tree().current_scene.add_child(projectile)
			
			# Spread the shotgun shots
			var dir = -$RigidBody3D.global_transform.basis.z
			var pos = $RigidBody3D.global_position
			
			var spread_angle = spread  # radians (~3 degrees)
			dir = (dir + Vector3(
				randf_range(-spread_angle, spread_angle),
				randf_range(-spread_angle, spread_angle),
				randf_range(-spread_angle, spread_angle)
			)).normalized()
			
			projectile.spawn(pos, dir)
		

func release():
	_trigger_released = true
