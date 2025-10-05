extends Node3D

@export var mouse_sensitivity: float = 0.001
var rotation_x: float = 0.0
var rotation_y: float = 0.0

var spin_speed: float = 90.0 # degrees per second
var move_speed: float = 0.1

var mouse_capture_enabled = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotateCamera(event)
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_P: # Open store
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			mouse_capture_enabled = true
			$Overlay/Store.visible = true
		if event.keycode == KEY_ESCAPE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			mouse_capture_enabled = true
			$Overlay/Store.visible = false

		if event.keycode == KEY_X:
			if mouse_capture_enabled:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				mouse_capture_enabled = false
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				mouse_capture_enabled = true
		if event.keycode == KEY_0:
			Resources.add_pap(1000)

func rotateCamera(event: InputEvent) -> void:
	rotation_y -= event.relative.x * mouse_sensitivity
	rotation_x -= event.relative.y * mouse_sensitivity
	rotation_x = clamp(rotation_x, -PI/2, PI/2) # limit vertical look
