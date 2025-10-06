extends Node2D

@onready var current_trophy: Label = $VBoxContainer/HBoxContainer2/current_trophy
@onready var max_trophy: Label = $VBoxContainer/HBoxContainer2/max_trophy

func _update_trophy_count() -> void:
	current_trophy.text = str(Resources.get_current_trophies())
	max_trophy.text = str(Resources.get_max_trophies())
	
func _ready() -> void:
	Resources.item_stored.connect(_on_item_stored)
	Resources.item_unstored.connect(_on_item_unstored)
	Resources.pap.connect(_on_update)
	Resources.trophy_get.connect(_update_trophy_count)
	_on_update()
	_update_trophy_count()

func _on_item_stored():
	var item = Resources.inventory_item as Node3D
	var camera = $VBoxContainer/SubViewportContainer/SubViewport/Camera3D
	var node = $VBoxContainer/SubViewportContainer/SubViewport/Node
	for child in node.get_children():
		node.remove_child(child)
	node.add_child(item)
	item.global_transform = camera.global_transform

	# Move it slightly forward, so it’s visible in front of the camera
	item.global_position += camera.global_transform.basis.z * -2

	item.rotation.x += 45
	item.rotation.z += 45

func _on_item_unstored():
	var node = $VBoxContainer/SubViewportContainer/SubViewport/Node
	for child in node.get_children():
		node.remove_child(child)

func _on_update():
	$VBoxContainer/HBoxContainer/PapCount.text = str(Resources.papCounter)
