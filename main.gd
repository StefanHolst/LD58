extends Node3D

var mouse_capture_enabled = false

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_P: # Open store
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			mouse_capture_enabled = true
			$Overlay/Store.visible = true
			Resources.enabled = false
		if event.keycode == KEY_ESCAPE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			mouse_capture_enabled = true
			$Overlay/Store.visible = false
			Resources.enabled = true

		if event.keycode == KEY_X:
			if mouse_capture_enabled:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				mouse_capture_enabled = false
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				mouse_capture_enabled = true
		if event.keycode == KEY_0:
			Resources.add_pap(1000)
