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
