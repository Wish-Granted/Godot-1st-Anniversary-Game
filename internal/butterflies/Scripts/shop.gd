extends TextureRect

@onready var shop_arm = $"Shop Arm"
@onready var shop_buttefly = $"Shop Butterfly"

var shop_elements: Dictionary

func _ready() -> void:
	init_element_dictionary()
	
func init_element_dictionary():
	shop_elements = {
	"arm": {
		"1": {
			"container"   : $"Shop Arm/Arm1",
			"icon"        : $"Shop Arm/Arm1/Icon",
			"cost_and_buy": $"Shop Arm/Arm1/CostBuy",
			"buy_button"  : $"Shop Arm/Arm1/CostBuy/Buy_Button"
		},
		"2": {
			"container"   : $"Shop Arm/Arm2",
			"icon"        : $"Shop Arm/Arm2/Icon",
			"cost_and_buy": $"Shop Arm/Arm2/CostBuy",
			"buy_button"  : $"Shop Arm/Arm2/CostBuy/Buy_Button"
		},
		"3": {
			"container"   : $"Shop Arm/Arm3",
			"icon"        : $"Shop Arm/Arm3/Icon",
			"cost_and_buy": $"Shop Arm/Arm3/CostBuy",
			"buy_button"  : $"Shop Arm/Arm3/CostBuy/Buy_Button"
		}
	},
	"butterfly": {
		"upgrade1": {
			"container"   : $"Shop Butterfly/Upgrade1",
			"icon"        : $"Shop Butterfly/Upgrade1/Icon",
			"cost_and_buy": $"Shop Butterfly/Upgrade1/CostBuy",
			"buy_button"  : $"Shop Butterfly/Upgrade1/CostBuy/Buy_Button"
		},
		"upgrade2": {
			"container"   : $"Shop Butterfly/Upgrade2",
			"icon"        : $"Shop Butterfly/Upgrade2/Icon",
			"cost_and_buy": $"Shop Butterfly/Upgrade2/CostBuy",
			"buy_button"  : $"Shop Butterfly/Upgrade2/CostBuy/Buy_Button"
		},
		"upgrade3": {
			"container"   : $"Shop Butterfly/Upgrade3",
			"icon"        : $"Shop Butterfly/Upgrade3/Icon",
			"cost_and_buy": $"Shop Butterfly/Upgrade3/CostBuy",
			"buy_button"  : $"Shop Butterfly/Upgrade3/CostBuy/Buy_Button"
		}
	}
}

func open_shop(shop: String) -> void:
	self.visible = true
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
	shop_arm.visible = false
	shop_buttefly.visible = false

func _on_focus_exited() -> void:
	close_shop()

func _on_close_button_pressed() -> void:
	close_shop()
	
func toggle_shader(element) -> void:
	var element_shader = element.material as ShaderMaterial
	var onoff = element_shader.get_shader_parameter("onoff")
	element_shader.set_shader_parameter("onoff", 0.0 if onoff == 1.0 else 1.0)
	
