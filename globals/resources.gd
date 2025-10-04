extends Node

@export var papCounter: int = 0;
@export var leftHand: Node = null
@export var rightHand: Node = null
signal item_dropped
var droppedItem: Node = null

func add_pap(pieces: int):
	papCounter += pieces

func pick_up(item: Node, is_left_hand: bool):
	if is_left_hand:
		# drops item..
		if leftHand != null:
			_place_item(leftHand)
		leftHand = item
	else:
		# drops item..
		if rightHand != null:
			_place_item(rightHand)
		rightHand = item

func drop(is_left_hand: bool):
	if is_left_hand:
		leftHand = null
	else:
		rightHand = null

func _place_item(item: Node):
	droppedItem = item;
	emit_signal("item_dropped")
