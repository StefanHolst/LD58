extends CharacterBody3D
class_name PlayerBody

@export var active: bool = false:
	set = set_active
@export var gravity: Vector3 = Vector3(0, 0, 0)
@export var camera: Camera3D
@export var speed: float = 3
@export var jump_height: float = 2.0
@export_range(0.00001, 0.01) var mouse_sensitivity: float = 0.01
@onready var ray_cast_3d: RayCast3D = $Camera3D/RayCast3D
@onready var grab: RayCast3D = $Camera3D/grab

func set_active(a: bool) -> void:
	if camera != null:
		camera.current = a
	set_process(a)
	set_physics_process(a)
	set_process_input(a)
	if grab:
		grab.set_physics_process(a)
	active = a
	

func _compute_jump_velocity() -> float:
	var vy_sq = max(0, 2 * jump_height * -gravity.y)
	return sqrt(vy_sq)

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	move_camera(Vector2(0, 0))
	set_active(active)

func _physics_process(dt: float):
	velocity += gravity * dt
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
	
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
	
func jump():
	velocity.y = _compute_jump_velocity()

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		move_camera(event.relative * mouse_sensitivity)
	if Input.is_action_pressed("left_hand"):
		$Camera3D/Pistol.trigger()
	if Input.is_action_just_released("left_hand"):
		$Camera3D/Pistol.release()

func move_camera_old(movement: Vector2):
	self.rotate_y(-movement.x * mouse_sensitivity)
	camera.rotate_x(movement.y * mouse_sensitivity)     

func move_camera(movement: Vector2):
	var camera_rotation_basis = Vector2(-rotation.y, -camera.rotation.x)

	camera_rotation_basis += movement
	camera_rotation_basis.y = clamp(camera_rotation_basis.y, -1.5, 1.2)
	
	transform.basis = Basis()
	camera.transform.basis = Basis()
	
	rotate_object_local(Vector3(0, 1, 0), -camera_rotation_basis.x)
	camera.rotate_object_local(Vector3(1, 0, 0), -camera_rotation_basis.y)
