extends VBoxContainer

@onready var shop_arm := $ShopArm
@onready var shop_butterfly := $ShopButterfly

func show_shop_button(button: String) -> void:
	if button == "arm":
		shop_arm.visible = true
	elif button == "butterfly":
		shop_butterfly.visible = true
