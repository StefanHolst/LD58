extends RigidBody3D

func _on_lifetime_timeout() -> void:
	queue_free()

func get_value() -> int:
	return 5
