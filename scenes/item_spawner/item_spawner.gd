class_name item_spawner
extends Node3D

@export var Item: PackedScene
@export var SpawnArea: Node3D

@export_range(1, 1000) var Count: int = 1

var isInitialized: bool = false

func get_node_aabb(node : Node3D = null, ignore_top_level : bool = true, bounds_transform : Transform3D = Transform3D()) -> AABB:
	var box : AABB
	var transform : Transform3D

	# we are going down the child chain, we want the aabb of each subsequent node to be on the same axis as the parent
	if bounds_transform.is_equal_approx(Transform3D()):
		transform = node.global_transform
	else:
		transform = bounds_transform
	
	# no more nodes. return default aabb
	if node == null:
		return AABB(Vector3(-0.2, -0.2, -0.2), Vector3(0.4, 0.4, 0.4))
	# makes sure the transform we get isn't distorted
	var top_xform : Transform3D = transform.affine_inverse() * node.global_transform

	# convert the node into visualinstance3D to access get_aabb() function.
	var visual_result : VisualInstance3D = node as VisualInstance3D
	if visual_result != null:
		box = visual_result.get_aabb()
	else:
		box = AABB()
	
	# xforms the transform with the box aabb for proper alignment I believe?
	box = top_xform * box
	# recursion
	for i : int in node.get_child_count():
		var child : Node3D = node.get_child(i) as Node3D
		if child && !(ignore_top_level && child.top_level):
			var child_box : AABB = get_node_aabb(child, ignore_top_level, transform)
			box = box.merge(child_box)
	
	return box

func _find_position(volume: AABB) -> Vector3:
	var start = Vector3(
		randf_range(volume.position.x, volume.end.x),
		abs(max(volume.position.y, volume.end.y))*2,
		randf_range(volume.position.z, volume.end.z))
		
	var height = -abs(volume.position.y) * 2

	var space_state = get_world_3d().direct_space_state
	var intersection = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(start, Vector3(start.x, height, start.z)))
	
	if not intersection.is_empty():
		return intersection["position"] as Vector3
	return start

func _process(_delta: float) -> void:
	if isInitialized:
		return
	isInitialized = true
	
	var aabb = get_node_aabb(SpawnArea, false)
	print("AABB: ", aabb)
	
	for i in range(1, Count):
		var new_item = Item.instantiate() as Node3D
		SpawnArea.add_child(new_item)
		new_item.position = _find_position(aabb)
		print("Spawned at ", new_item.position)
