extends CharacterBody3D
class_name Boat

@export var active: bool = false:
	set = set_activate

@export var camera: Camera3D
@export var speed: float = 3
@export_range(0.00001, 0.01) var mouse_sensitivity: float = 0.001 

var camera_rotation_basis = Vector2(0, 0)

func get_player() -> PlayerBody:
	for c in get_children():
		if c is PlayerBody:
			return c
	return null

func set_activate(a: bool):
	active = a
	if camera != null:
		camera.current = a
	active = a

func _ready() -> void:
	set_activate(active)

func _physics_process(dt: float):
	if not active:
		return
	
	var fx: float = 0.0
	if Input.is_action_pressed("move_forward"):
		fx -= 1.0
	if Input.is_action_pressed("move_backward"):
		fx += 1.0
	
	var rl: float = 0.0
	if Input.is_action_pressed("move_right"):
		rl += 1.0
	if Input.is_action_pressed("move_left"):
		rl -= 1.0
	
	var forward_basis = transform.basis.z * speed * fx
	var rl_basis = transform.basis.x * speed * rl
	velocity.x = forward_basis.x + rl_basis.x
	velocity.z = forward_basis.z + rl_basis.z
	
	move_and_slide()
	
	if Input.is_action_just_pressed("ship_mode"):
		var p = get_player()
		if p != null:
			active = false
			p.active = true
			p.reparent(get_tree().root)

func _input(event: InputEvent):
	if not active:
		return

	if event is InputEventMouseMotion:
		move_camera(event.relative * mouse_sensitivity)    

func move_camera(movement: Vector2):
	camera_rotation_basis += movement
	camera_rotation_basis.y = clamp(camera_rotation_basis.y, -1.5, 1.2)
	
	transform.basis = Basis()
	camera.transform.basis = Basis()
	
	rotate_object_local(Vector3(0, 1, 0), -camera_rotation_basis.x)
	camera.rotate_object_local(Vector3(1, 0, 0), -camera_rotation_basis.y)

	
