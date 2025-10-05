extends Node2D

func _ready() -> void:
	Resources.item_stored.connect(_on_item_stored)
	Resources.item_unstored.connect(_on_item_unstored)

func _on_item_stored():
	var item = Resources.inventory_item as Node3D
	var camera = $HFlowContainer/SubViewportContainer/SubViewport/Camera3D
	var node = $HFlowContainer/SubViewportContainer/SubViewport/Node
	for child in node.get_children():
		node.remove_child(child)
	node.add_child(item)
	item.global_transform = camera.global_transform

	# Move it slightly forward, so it’s visible in front of the camera
	item.global_position += camera.global_transform.basis.z * -2

	item.rotation.x += 45
	item.rotation.z += 45

func _on_item_unstored():
	var node = $HFlowContainer/SubViewportContainer/SubViewport/Node
	for child in node.get_children():
		node.remove_child(child)
