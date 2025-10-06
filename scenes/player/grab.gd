extends RayCast3D

func _try_grab_object(is_left_hand: bool):
	var next_object = get_collider()

	if (not next_object):
		Resources.unstore(is_left_hand)
		return
	
	# Ignore the terrain
	var parent = next_object.get_parent()
	while (parent):
		if parent.is_in_group("terrain"):
			return
		parent = parent.get_parent()
	
	if next_object is Node3D and next_object is not Boat:
		Resources.pick_up(next_object, is_left_hand)

func _move_grabbed_object(dt: float):
	if Resources.leftHand != null:
		Resources.leftHand.global_transform = $grab_left.global_transform
	if Resources.rightHand != null:
		Resources.rightHand.global_transform = $grab_right.global_transform

func _physics_process(dt: float):
	if Input.is_action_just_pressed("left_hand"):
		if Resources.leftHand == null:
			_try_grab_object(true)
		else:
			Resources.drop(true)
	if Input.is_action_just_pressed("right_hand"):
		if Resources.rightHand == null:
			_try_grab_object(false)
		else:
			Resources.drop(false)
	if Input.is_key_pressed(KEY_Q):
		Resources.store(true)
	if Input.is_key_pressed(KEY_E):
		Resources.store(false)
	_move_grabbed_object(dt)
