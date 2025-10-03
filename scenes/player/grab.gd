extends RayCast3D

@onready var object: Node3D = null
@onready var grab_point: Node3D = $grab_point

func _try_grab_object():
	var next_object = get_collider()
	if next_object is Node3D:
		print(next_object)
		object = next_object

func _move_grabbed_object(dt: float):
	if object == null:
		return
	
	object.global_position = grab_point.global_position

func _physics_process(dt: float):
	if Input.is_action_pressed("grab"):
		_try_grab_object()
		_move_grabbed_object(dt)
	else:
		object = null
