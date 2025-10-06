extends Node3D
class_name Lazer

@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var timer: Timer = $Timer
@onready var mesh: MeshInstance3D = $mesh


func _process(delta: float) -> void:
	if not timer.is_stopped():
		return
		
	var body = ray_cast_3d.get_collider()
	if body is PlayerBody:
		Resources.remove_pap(1)
		timer.start()
	
	if ray_cast_3d.is_colliding():
		var p = ray_cast_3d.get_collision_point()
		var d = global_position.distance_to(p)
		#mesh.scale = Vector3(1, 1, d)


func aim(p: Vector3, dt: float) -> void:
	var d = p - global_position
	var new_target = Basis.looking_at(d, Vector3.UP, true)
	var new_rotation = new_target.get_rotation_quaternion()
	global_rotation = global_basis.get_rotation_quaternion().slerp(new_rotation, 0.95 * dt).get_euler()
	scale = Vector3(1, 1, d.length())
	if ray_cast_3d.is_colliding():
		var p2 = ray_cast_3d.get_collision_point()
		var d2 = global_position.distance_to(p2)
		mesh.scale = Vector3(1, d2 / d.length(), 1)
		

	#ray_cast_3d.scale = Vector3(1, 1, p.length())
