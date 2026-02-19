extends TextureRect

@onready var shop_arm = $"Shop Arm"
@onready var shop_buttefly = $"Shop Butterfly"

func open_shop(shop: String) -> void:
	self.visible = true
	self.grab_focus()
	if shop == "arm":
		shop_arm.visible = true
		shop_buttefly.visible = false
	elif shop == "butterfly":
		shop_buttefly.visible = true
		shop_arm.visible = false
	else:
		print("shop not found")
		close_shop()
	
func close_shop() -> void:
	self.visible = false

func _on_focus_exited() -> void:
	close_shop()
