extends RayCast3D

func _try_grab_object(is_left_hand: bool):
	var next_object = get_collider()
	if next_object is Node3D:
		Resources.pick_up(next_object, is_left_hand)
	else:
		Resources.unstore(is_left_hand)

func _move_grabbed_object(dt: float):
	if Resources.leftHand != null:
		Resources.leftHand.global_position = $grab_left.global_position
	if Resources.rightHand != null:
		Resources.rightHand.global_position = $grab_right.global_position

func _physics_process(dt: float):
	if Input.is_action_just_pressed("left_hand_grab"):
		if Resources.leftHand == null:
			_try_grab_object(true)
		else:
			Resources.drop(true)
	if Input.is_action_just_pressed("right_hand_grab"):
		if Resources.rightHand == null:
			_try_grab_object(false)
		else:
			Resources.drop(false)
	if Input.is_key_pressed(KEY_Q):
		Resources.store(true)
	if Input.is_key_pressed(KEY_E):
		Resources.store(false)
	_move_grabbed_object(dt)
