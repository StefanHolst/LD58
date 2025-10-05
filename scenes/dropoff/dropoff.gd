extends Node3D

func _ready() -> void:
	Resources.item_dropped.connect(_on_item_dropped)

func _on_item_dropped():
	if $Area3D.overlaps_body(Resources.dropped_item):
		Resources.add_pap(1)
		Resources.dropped_item.queue_free()
