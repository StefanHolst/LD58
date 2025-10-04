extends RayCast3D

@onready var object: Node3D = null

func _try_grab_object(is_left_hand: bool):
	var next_object = get_collider()
	if next_object is Node3D:
		Resources.pick_up(next_object, is_left_hand)

func _move_grabbed_object(dt: float):
	if Resources.leftHand != null:
		Resources.leftHand.global_position = $grab_left.global_position
	if Resources.rightHand != null:
		Resources.rightHand.global_position = $grab_right.global_position

func _physics_process(dt: float):
	if Input.is_action_pressed("left_hand_grab"):
		_try_grab_object(true)
	if Input.is_action_pressed("right_hand_grab"):
		_try_grab_object(false)
	if Input.is_key_pressed(KEY_Q):
		Resources.drop(true)
	if Input.is_key_pressed(KEY_E):
		Resources.drop(false)
	_move_grabbed_object(dt)
