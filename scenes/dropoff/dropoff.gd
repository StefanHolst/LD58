extends Node3D

func _ready() -> void:
	$Area3D.body_entered.connect(_on_body_entered)

func _on_body_entered(item: Node):
	if item.is_in_group("grabable"):
		Resources.add_pap(1)
		Resources.dropped_item.queue_free()
