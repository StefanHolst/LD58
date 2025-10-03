extends CharacterBody3D

@export var gravity: Vector3 = Vector3(0, 0, 0)
@export var camera: Camera3D
@export var speed: float = 3
@export_range(0.00001, 0.01) var mouse_sensitivity: float = 0.01 

var camera_rotation_basis = Vector2(0, 0)

func _ready():
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    move_camera(Vector2(0, 0))

func _physics_process(dt: float):
    var camera_basis : Basis = global_transform.basis
    var camera_z := camera_basis.z
    var camera_x := camera_basis.x
    velocity += gravity * dt
    
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
    
    var forward_basis = Vector3(camera_z.x, 0, camera_z.z).normalized() * speed * fx
    var rl_basis = Vector3(camera_x.x, 0, camera_x.z).normalized() * speed * rl
    velocity.x = forward_basis.x + rl_basis.x
    velocity.z = forward_basis.z + rl_basis.z
    
    move_and_slide()
    

func _input(event: InputEvent):
    if event is InputEventMouseMotion:
        move_camera(event.relative * mouse_sensitivity)

func move_camera_old(movement: Vector2):
    self.rotate_y(-movement.x * mouse_sensitivity)
    camera.rotate_x(movement.y * mouse_sensitivity)     

func move_camera(movement: Vector2):
    camera_rotation_basis += movement
    camera_rotation_basis.y = clamp(camera_rotation_basis.y, -1.5, 1.2)
    
    transform.basis = Basis()
    camera.transform.basis = Basis()
    
    rotate_object_local(Vector3(0, 1, 0), -camera_rotation_basis.x)
    camera.rotate_object_local(Vector3(1, 0, 0), -camera_rotation_basis.y)
