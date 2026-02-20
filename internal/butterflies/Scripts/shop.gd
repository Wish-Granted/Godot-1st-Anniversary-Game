extends TextureRect

@onready var shop_arm = $"Shop Arm"
@onready var shop_buttefly = $"Shop Butterfly"

@onready var score_bar = $"../Score_Bar"

@onready var player = $"../Player"

const shop_arm_bg = preload("res://internal/butterflies/Assests/Shop/Shop BG Arm.png")
const shop_butterfly_bg = preload("res://internal/butterflies/Assests/Shop/Shop BG Butterfly.png")

var shop_elements: Dictionary[String, Dictionary]

func _ready() -> void:
	init_element_dictionary()
	
func init_element_dictionary():
	shop_elements = {
	"arm": {
		"1": {
			"container"   : $"Shop Arm/Arm1",
			"icon"        : $"Shop Arm/Arm1/Icon",
			"cost_and_buy": $"Shop Arm/Arm1/CostBuy",
			"cost"        : $"Shop Arm/Arm1/CostBuy/HBoxContainer/Cost",
			"buy_button"  : $"Shop Arm/Arm1/CostBuy/Buy_Button"
		},
		"2": {
			"container"   : $"Shop Arm/Arm2",
			"icon"        : $"Shop Arm/Arm2/Icon",
			"cost_and_buy": $"Shop Arm/Arm2/CostBuy",
			"cost"        : $"Shop Arm/Arm2/CostBuy/HBoxContainer/Cost",
			"buy_button"  : $"Shop Arm/Arm2/CostBuy/Buy_Button"
		},
		"3": {
			"container"   : $"Shop Arm/Arm3",
			"icon"        : $"Shop Arm/Arm3/Icon",
			"cost_and_buy": $"Shop Arm/Arm3/CostBuy",
			"cost"        : $"Shop Arm/Arm3/CostBuy/HBoxContainer/Cost",
			"buy_button"  : $"Shop Arm/Arm3/CostBuy/Buy_Button"
		}
	},
	"butterfly": {
		"upgrade1": {
			"container"   : $"Shop Butterfly/Upgrade1",
			"icon"        : $"Shop Butterfly/Upgrade1/Icon",
			"cost_and_buy": $"Shop Butterfly/Upgrade1/CostBuy",
			"cost"        : $"Shop Butterfly/Upgrade1/CostBuy/HBoxContainer/Cost",
			"buy_button"  : $"Shop Butterfly/Upgrade1/CostBuy/Buy_Button"
		},
		"upgrade2": {
			"container"   : $"Shop Butterfly/Upgrade2",
			"icon"        : $"Shop Butterfly/Upgrade2/Icon",
			"cost_and_buy": $"Shop Butterfly/Upgrade2/CostBuy",
			"cost"        : $"Shop Butterfly/Upgrade2/CostBuy/HBoxContainer/Cost",
			"buy_button"  : $"Shop Butterfly/Upgrade2/CostBuy/Buy_Button"
		},
		"upgrade3": {
			"container"   : $"Shop Butterfly/Upgrade3",
			"icon"        : $"Shop Butterfly/Upgrade3/Icon",
			"cost_and_buy": $"Shop Butterfly/Upgrade3/CostBuy",
			"cost"        : $"Shop Butterfly/Upgrade3/CostBuy/HBoxContainer/Cost",
			"buy_button"  : $"Shop Butterfly/Upgrade3/CostBuy/Buy_Button"
		}
	}
}

func open_shop(shop: String) -> void:
	update_shop(shop)
	self.visible = true
	if shop == "arm":
		self.texture = shop_arm_bg
		shop_arm.visible = true
		shop_buttefly.visible = false
	elif shop == "butterfly":
		self.texture = shop_butterfly_bg
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
	
func set_shader(element, shader_on: bool) -> void:
	var element_shader = element.material as ShaderMaterial
	element_shader.set_shader_parameter("onoff", 1.0 if shader_on else 0.0)
	
func update_shop(shop: String) -> void:
	for shop_item_name in shop_elements[shop]:
		var shop_item = shop_elements[shop][shop_item_name]
		if shop == "arm":
			if int(shop_item_name) == player.arm_level:
				set_shader(shop_item["icon"], false)
				shop_item["cost_and_buy"].visible = false
			elif int(shop_item_name) > player.arm_level+1:
				shop_item["container"].visible = false
			elif int(shop_item_name) <= player.arm_level+1:
				shop_item["container"].visible = true
		
		if score_bar.current_butterfly_count >= int(shop_item["cost"].text):
			set_shader(shop_item["buy_button"], false)
		else:
			set_shader(shop_item["buy_button"], true)

func _on_arm1_buy_button_pressed() -> void:
	if score_bar.current_butterfly_count >= int(shop_elements["arm"]["1"]["cost"].text):
		score_bar.update_score(-20)
		player.update_arm_sprite(1)
		update_shop("arm")

func _on_arm2_buy_button_pressed() -> void:
	if score_bar.current_butterfly_count >= int(shop_elements["arm"]["1"]["cost"].text):
		score_bar.update_score(-100)
		player.update_arm_sprite(1)
		update_shop("arm")

func _on_arm3_buy_button_pressed() -> void:
	if score_bar.current_butterfly_count >= int(shop_elements["arm"]["1"]["cost"].text):
		score_bar.update_score(-1000)
		player.update_arm_sprite(1)
		update_shop("arm")
