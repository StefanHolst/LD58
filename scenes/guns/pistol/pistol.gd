extends Node3D

@export var projectile_scene: PackedScene
var fire_rate: float = 0.5
var _last_shot: float = 0
var _can_shoot = true
var _trigger_released = true

func _ready() -> void:
	Resources.pap.connect(Callable(self, "_update"))

func _update():
	fire_rate = 0.5
	if Resources.pistol_upgrades & 1 != 0:
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
	if _can_shoot and _trigger_released and Resources.papCounter >= 1:
		_trigger_released = false
		_can_shoot = false
		Resources.remove_pap(1)
		var projectile = projectile_scene.instantiate()
		projectile.damage = 1
		if Resources.pistol_upgrades & 2 != 0:
			projectile.damage *= 2
		get_tree().current_scene.add_child(projectile)
		projectile.spawn($RigidBody3D.global_position, -$RigidBody3D.global_transform.basis.z)

func release():
	_trigger_released = true
