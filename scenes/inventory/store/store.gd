extends Panel

@export var pistol_scene: PackedScene
@export var shotgun_scene: PackedScene
#@export var boat_scene: PackedScene

var upgrade_row_scene = preload("res://scenes/inventory/store/upgrade_row.tscn")
@onready var Upgrades = $VBoxContainer/HBoxContainer/Upgrades/Items
@onready var grid = $VBoxContainer/HBoxContainer/Listings/VBoxContainer
@onready var Items = $VBoxContainer/HBoxContainer/Items/Items

enum ItemType {
	Pistol = 1,
	Shotgun = 2,
	Boat = 4
}
const ITEM_PRICE_PISTOL = 200
const ITEM_PRICE_SHOTGUN = 1000
const ITEM_PRICE_BOAT = 100

const UPGRADE_PISTOL_FIRERATE_TEXT = "Fire Rate 60rpm -> 120rpm"
const UPGRADE_PISTOL_FIRERATE_PRICE = 200
const UPGRADE_PISTOL_DAMAGE_TEXT = "Damage 1p -> 2p"
const UPGRADE_PISTOL_DAMAGE_PRICE = 200
const UPGRADE_SHOTGUN_PELLETS_TEXT = "More Pellets 5 -> 10"
const UPGRADE_SHOTGUN_PELLETS_PRICE = 1000
const UPGRADE_SHOTGUN_SPREAD_TEXT = "Spread 3deg -> 5deg"
const UPGRADE_SHOTGUN_SPREAD_PRICE = 1000
const UPGRADE_SHOTGUN_FIRERATE_TEXT = "Fire Rate 30rpm -> 120rom"
const UPGRADE_SHOTGUN_FIRERATE_PRICE = 1000

func _ready() -> void:
	_upgrades_list()
	_items_list()

	Upgrades.connect("item_selected", Callable(self, "_upgrades_selected"))
	Items.connect("item_selected", Callable(self, "_items_buy"))

func _upgrades_list():
	Upgrades.clear()
	
	# fill in the upgrades menu
	if Resources.items_unlocked & ItemType.Pistol != 0:
		Upgrades.add_item("Pistol")
	if Resources.items_unlocked & ItemType.Shotgun != 0:
		Upgrades.add_item("Shotgun")
	if Resources.items_unlocked & ItemType.Boat != 0:
		Upgrades.add_item("Boat")

func _upgrades_selected(index: int):
	var selected_text = Upgrades.get_item_text(index)
	_clear_list_upgrades()

	if selected_text == "Pistol": # pistol
		_list_pistol_upgrades()
	elif selected_text == "Shotgun": # shotgun
		_list_shotgun_upgrades()
		pass
	elif index == 2: #  boat
		pass

func _items_list():
	$VBoxContainer/HBoxContainer/Items/Items.add_item("Pistol (" + str(ITEM_PRICE_PISTOL) + "p)")
	$VBoxContainer/HBoxContainer/Items/Items.add_item("Shotgun (" + str(ITEM_PRICE_SHOTGUN) + "p)")
	$VBoxContainer/HBoxContainer/Items/Items.add_item("Boat (" + str(ITEM_PRICE_BOAT) + "p)")

func _items_buy(index: int):
	$VBoxContainer/HBoxContainer/Items/Items.deselect_all()
	if index == 0:
		if Resources.papCounter > ITEM_PRICE_PISTOL:
			Resources.remove_pap(ITEM_PRICE_PISTOL)
			Resources.items_unlocked |= ItemType.Pistol
			# Spawn the item
			var pistol = pistol_scene.instantiate()
			var forward = -Resources.player.global_transform.basis.z
			pistol.global_position = Resources.player.global_position + forward * 3.0
			get_tree().current_scene.add_child(pistol)
	if index == 1:
		if Resources.papCounter > ITEM_PRICE_SHOTGUN:
			Resources.remove_pap(ITEM_PRICE_SHOTGUN)
			Resources.items_unlocked |= ItemType.Shotgun
			# spawn the shotgun
			var shotgun = shotgun_scene.instantiate()
			var forward = -Resources.player.global_transform.basis.z
			shotgun.global_position = Resources.player.global_position + forward * 3.0
			get_tree().current_scene.add_child(shotgun)
	if index == 2:
		if Resources.papCounter > ITEM_PRICE_BOAT:
			Resources.remove_pap(ITEM_PRICE_BOAT)
			Resources.items_unlocked |= ItemType.Boat
			# TODO: spawn the boat

	_upgrades_list()

func _clear_list_upgrades():
	for c in grid.get_children():
		grid.remove_child(c)

func _list_pistol_upgrades():
	_clear_list_upgrades()
	_add_row(UPGRADE_PISTOL_FIRERATE_TEXT, UPGRADE_PISTOL_FIRERATE_PRICE, Resources.pistol_upgrades & 1 != 0)
	_add_row(UPGRADE_PISTOL_DAMAGE_TEXT, UPGRADE_PISTOL_DAMAGE_PRICE, Resources.pistol_upgrades & 2 != 0)
func _list_shotgun_upgrades():
	_clear_list_upgrades()
	_add_row(UPGRADE_SHOTGUN_PELLETS_TEXT, UPGRADE_SHOTGUN_PELLETS_PRICE, Resources.shotgun_upgrades & 1 != 0)
	_add_row(UPGRADE_SHOTGUN_SPREAD_TEXT, UPGRADE_SHOTGUN_SPREAD_PRICE, Resources.shotgun_upgrades & 2 != 0)
	_add_row(UPGRADE_SHOTGUN_FIRERATE_TEXT, UPGRADE_SHOTGUN_FIRERATE_PRICE, Resources.shotgun_upgrades & 4 != 0)

func _add_row(title: String, price: int, owned: bool):
	var row = upgrade_row_scene.instantiate()
	row.title = title
	row.price = price
	row.owned = owned
	row.enabled = Resources.papCounter > price
	row.connect("row_pressed", Callable(self, "_on_row_pressed"))
	grid.add_child(row)

func _on_row_pressed(row):
	if row.title == UPGRADE_PISTOL_FIRERATE_TEXT:
		Resources.remove_pap(UPGRADE_PISTOL_FIRERATE_PRICE)
		Resources.pistol_upgrades |= 1
	if row.title == UPGRADE_PISTOL_DAMAGE_TEXT:
		Resources.remove_pap(UPGRADE_PISTOL_DAMAGE_PRICE)
		Resources.pistol_upgrades |= 2

	if row.title == UPGRADE_SHOTGUN_PELLETS_TEXT:
		Resources.remove_pap(UPGRADE_SHOTGUN_PELLETS_PRICE)
		Resources.shotgun_upgrades |= 1
	if row.title == UPGRADE_SHOTGUN_SPREAD_TEXT:
		Resources.remove_pap(UPGRADE_SHOTGUN_SPREAD_PRICE)
		Resources.shotgun_upgrades |= 2
	if row.title == UPGRADE_SHOTGUN_FIRERATE_TEXT:
		Resources.remove_pap(UPGRADE_SHOTGUN_FIRERATE_PRICE)
		Resources.shotgun_upgrades |= 4
	
	Resources.emit_signal("pap")
	_upgrades_selected(Upgrades.get_selected_items()[0])
