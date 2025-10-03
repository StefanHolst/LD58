extends Node3D

@onready var papPlayer: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _on_rigid_body_3d_body_entered(body: Node) -> void:
	#if not papPlayer.playing:
	papPlayer.pitch_scale = randfn(1, 0.1)
	papPlayer.play()
	print("Enter ", body)

func _on_rigid_body_3d_body_exited(body: Node) -> void:
	#print("Exit ", body)
	pass
	#papPlayer.stop()

func _ready() -> void:
	# disable hinge / physics
	$HingeJoint3D/RigidBody3D.freeze = true
	$HingeJoint3D/RigidBody3D2.freeze = true

func enable():
	# Enable hinge / physics - Now everything starts collapsing
	$HingeJoint3D/RigidBody3D.freeze = false
	$HingeJoint3D/RigidBody3D2.freeze = false
