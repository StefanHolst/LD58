extends HBoxContainer

func setup(title: String, price: int, owned: bool):
	$Title.text = title
	$Price.text = str(price) + "p"
	$Button.visible = !owned
