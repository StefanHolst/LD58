extends Node3D

func _ready() -> void:
	$Area3D.body_entered.connect(_on_body_entered)

func _on_body_entered(item: Node):
	if item.is_in_group("grabable"):
		Resources.add_pap(1)
		item.queue_free()
	
	#var grabable = false
	#var parent = item
	#while (parent):
		#if parent.is_in_group("grabable"):
			#grabable = true
			#break
		#parent = parent.get_parent()
#
	#if grabable:
		#Resources.add_pap(1)
		#item.queue_free()
