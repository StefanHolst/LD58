extends Node
class_name ResoucesHandler

const INITIAL_PAP_COUNT = 20

signal pap
signal damage_taken
signal player_died
signal item_dropped
signal item_stored
signal item_unstored
signal game_was_won

var pistol_upgrades: int = 0
var shotgun_upgrades: int = 0
var items_unlocked: int = 0 # bitmask of Items enum

var papCounter: int = INITIAL_PAP_COUNT;
var enabled = true

# Inventory
var leftHand: Node = null
var rightHand: Node = null
var player: Node = null
var dropped_item: Node = null
var inventory_item: Node = null
var _inventory_item_parent: Node = null

func win_game() -> void:
	game_was_won.emit()

func reset() -> void:
	leftHand = null
	rightHand = null
	player = null
	dropped_item = null
	inventory_item = null
	_inventory_item_parent = null
	papCounter = INITIAL_PAP_COUNT
	items_unlocked = 0
	pistol_upgrades = 0
	shotgun_upgrades = 0

func restart_game() -> void:
	reset()
	get_tree().reload_current_scene()

func add_pap(pieces: int):
	papCounter += pieces
	emit_signal("pap")

func remove_pap(pieces: int):
	papCounter -= pieces
	papCounter = max(0, papCounter)
	emit_signal("pap")
	damage_taken.emit()
	if papCounter <= 0:
		player_died.emit()

func pick_up(item: Node, is_left_hand: bool):
	drop(is_left_hand)
	if item is RigidBody3D:
		item.freeze = true
			
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
			emit_signal("item_stored")
	else:
		if rightHand != null:
			inventory_item = rightHand
			rightHand = null
			_inventory_item_parent = inventory_item.get_parent()
			_inventory_item_parent.remove_child(inventory_item)
			emit_signal("item_stored")

func drop(is_left_hand: bool):
	if is_left_hand:
		if leftHand == null:
			return
		dropped_item = leftHand
		if dropped_item is Node3D:
			dropped_item.basis = Basis()
		if dropped_item is RigidBody3D:
			dropped_item.freeze = false
		leftHand = null
		emit_signal("item_dropped")
	else:
		if rightHand == null:
			return
		dropped_item = rightHand
		if dropped_item is Node3D:
			dropped_item.basis = Basis()
		if dropped_item is RigidBody3D:
			dropped_item.freeze = false
		rightHand = null
		emit_signal("item_dropped")

func unstore(is_left_hand: bool):
	if inventory_item == null:
		return

	emit_signal("item_unstored")
	get_tree().root.add_child(inventory_item)
				
	if is_left_hand:
		leftHand = inventory_item
	else:
		rightHand = inventory_item
	inventory_item = null

func bought_item(item: int):
	items_unlocked &= 1 << item
	emit_signal("pap")
