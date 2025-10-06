extends HBoxContainer

signal row_pressed(row)

var title = null
var price: int = 0
var owned: bool = false
var enabled: bool = false

func _ready() -> void:
	$Title.text = title
	$Price.text = str(price) + "p"
	$Button.visible = !owned
	$Button.disabled = !enabled
	$Button.connect("pressed", Callable(self, "_on_button_pressed"))

func _on_button_pressed():
	emit_signal("row_pressed", self)
