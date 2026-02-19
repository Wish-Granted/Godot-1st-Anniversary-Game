extends VBoxContainer

@onready var shop_button_arm := $ShopArm
@onready var shop_button_butterfly := $ShopButterfly

@onready var shop_gui = $"../shop"

func show_shop_button(button: String) -> void:
	if button == "arm":
		shop_button_arm.visible = true
	elif button == "butterfly":
		shop_button_butterfly.visible = true

func _on_shop_arm_pressed() -> void:
	print("arm pressed")
	if shop_gui.shop_arm.visible == false:
		shop_gui.open_shop("arm")
	else:
		shop_gui.close_shop()

func _on_shop_butterfly_pressed() -> void:
	print("butterfly pressed")
	if shop_gui.shop_buttefly.visible == false:
		shop_gui.open_shop("butterfly")
	else:
		shop_gui.close_shop()
