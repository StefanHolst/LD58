extends Panel

func _ready() -> void:
	_list_upgrades()
	_list_items()
	$VBoxContainer/HBoxContainer/Items/Items.connect("item_selected", Callable(self, "_buy_item"))

func _list_upgrades():
	# fill in the upgrades menu
	$VBoxContainer/HBoxContainer/Upgrades/Items.add_item("Pistol")
	$VBoxContainer/HBoxContainer/Upgrades/Items.add_item("Shotgun")
	$VBoxContainer/HBoxContainer/Upgrades/Items.add_item("Boat")
	if Resources.items && Resources.ItemType.Pistol:
		$VBoxContainer/HBoxContainer/Upgrades/Items.add_item("Pistol")
	if Resources.items && Resources.ItemType.Shotgun:
		$VBoxContainer/HBoxContainer/Upgrades/Items.add_item("Shotgun")
	if Resources.items && Resources.ItemType.Boat:
		$VBoxContainer/HBoxContainer/Upgrades/Items.add_item("Boat")
	
func _list_items():
	$VBoxContainer/HBoxContainer/Items/Items.add_item("Pistol (" + str(Resources.ITEM_PRICE_PISTOL) + "p)")
	$VBoxContainer/HBoxContainer/Items/Items.add_item("Shotgun (" + str(Resources.ITEM_PRICE_SHOTGUN) + "p)")
	$VBoxContainer/HBoxContainer/Items/Items.add_item("Boat (" + str(Resources.ITEM_PRICE_BOAT) + "p)")

func _buy_item(index: int):
	$VBoxContainer/HBoxContainer/Items/Items.deselect_all()
	if index == Resources.ItemType.Pistol:
		if Resources.papCounter > Resources.ITEM_PRICE_PISTOL:
			Resources.remove_pap(Resources.ITEM_PRICE_PISTOL)
			# spawn the pistol
		pass
	if index == Resources.ItemType.Shotgun:
		pass
	if index == Resources.ItemType.Boat:
		pass
