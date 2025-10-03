extends Node3D

@export var mouse_sensitivity: float = 0.001
var rotation_x: float = 0.0
var rotation_y: float = 0.0

var spin_speed: float = 90.0 # degrees per second
var move_speed: float = 0.1


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Engine.time_scale = 0.5

func _process(delta: float) -> void:
	# Spin around Y axis
	$MeshInstance3D.rotate_y(deg_to_rad(spin_speed * delta))
	
	# Move camera
	moveCamera()
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotateCamera(event)
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_C:
			$Camera3D.position.z -= move_speed

func rotateCamera(event: InputEvent) -> void:
	rotation_y -= event.relative.x * mouse_sensitivity
	rotation_x -= event.relative.y * mouse_sensitivity
	rotation_x = clamp(rotation_x, -PI/2, PI/2) # limit vertical look

	$Camera3D.rotation.y = rotation_y
	$Camera3D.rotation.x = rotation_x
	
func moveCamera() -> void:
	var forward = -$Camera3D.transform.basis.z
	var right   =  $Camera3D.transform.basis.x
	var up      =  $Camera3D.transform.basis.y
	
	if Input.is_action_pressed("ui_up"):
		$Camera3D.position += forward * move_speed
	if Input.is_action_pressed("ui_down"):
		$Camera3D.position -= forward * move_speed
	if Input.is_action_pressed("ui_left"):
		$Camera3D.position -= right * move_speed
	if Input.is_action_pressed("ui_right"):
		$Camera3D.position += right * move_speed
	if Input.is_action_pressed("ui_space"):
		$Camera3D.position += up * move_speed
	if Input.is_action_pressed("ui_c"):
		$Camera3D.position -= up * move_speed
