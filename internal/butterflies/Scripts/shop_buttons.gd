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
	print("arm opened")
	shop_gui.open_shop("arm")

func _on_shop_butterfly_pressed() -> void:
	shop_gui.open_shop("butterfly")
	print("butterfly opened")

	
