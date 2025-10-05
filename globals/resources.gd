extends Node
class_name ResoucesHandler

@export var papCounter: int = 5;
signal pap
@export var leftHand: Node = null
@export var rightHand: Node = null
signal item_dropped
var dropped_item: Node = null
signal item_stored
signal item_unstored
var inventory_item: Node = null
var _inventory_item_parent: Node = null

func add_pap(pieces: int):
	papCounter += pieces
	emit_signal("pap")

func remove_pap(pieces: int):
	papCounter -= pieces
	papCounter = max(0, papCounter)
	emit_signal("pap")

func pick_up(item: Node, is_left_hand: bool):
	drop(is_left_hand)
	if is_left_hand:
		leftHand = item
	else:
		rightHand = item

func store(is_left_hand: bool):
	if is_left_hand:
		if leftHand != null:
			inventory_item = leftHand
			leftHand = null
			_inventory_item_parent = inventory_item.get_parent()
			_inventory_item_parent.remove_child(inventory_item)
			inventory_item.freeze = true
			emit_signal("item_stored")
	else:
		if rightHand != null:
			inventory_item = rightHand
			rightHand = null
			_inventory_item_parent = inventory_item.get_parent()
			_inventory_item_parent.remove_child(inventory_item)
			inventory_item.freeze = true
			emit_signal("item_stored")

func drop(is_left_hand: bool):
	if is_left_hand:
		if leftHand == null:
			return
		dropped_item = leftHand
		leftHand = null
		emit_signal("item_dropped")
	else:
		if rightHand == null:
			return
		dropped_item = rightHand
		rightHand = null
		emit_signal("item_dropped")

func unstore(is_left_hand: bool):
	if inventory_item == null:
		return

	emit_signal("item_unstored")
	_inventory_item_parent.add_child(inventory_item)
	inventory_item.freeze = false
	if is_left_hand:
		leftHand = inventory_item
	else:
		rightHand = inventory_item
	inventory_item = null
