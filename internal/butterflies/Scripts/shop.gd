extends TextureRect

@onready var shop_arm = $"Shop Arm"
@onready var shop_buttefly = $"Shop Butterfly"

@onready var score_bar = $"../Score_Bar"

@onready var player = $"../Player"

@onready var chocolate_rose_spawner = $"../Chocolate Rose Spawner"
@onready var butterfly_spawner = $"../Butterfly Spawner"

const shop_arm_bg = preload("res://internal/butterflies/Assests/Shop/Shop BG Arm.png")
const shop_butterfly_bg = preload("res://internal/butterflies/Assests/Shop/Shop BG Butterfly.png")

var shop_elements: Dictionary[String, Dictionary]

var shop_butterfly_upgrade_levels = [0,0,0,0]

func _ready() -> void:
	init_element_dictionary()

func init_element_dictionary():
	shop_elements = {
	"arm": {
		"1": {
			"id"          : "arm1",
			"container"   : $"Shop Arm/Arm1",
			"icon"        : $"Shop Arm/Arm1/Icon",
			"cost_and_buy": $"Shop Arm/Arm1/CostBuy",
			"cost"        : $"Shop Arm/Arm1/CostBuy/HBoxContainer/Cost",
			"buy_button"  : $"Shop Arm/Arm1/CostBuy/Buy_Button"
		},
		"2": {
			"id"          : "arm2",
			"container"   : $"Shop Arm/Arm2",
			"icon"        : $"Shop Arm/Arm2/Icon",
			"cost_and_buy": $"Shop Arm/Arm2/CostBuy",
			"cost"        : $"Shop Arm/Arm2/CostBuy/HBoxContainer/Cost",
			"buy_button"  : $"Shop Arm/Arm2/CostBuy/Buy_Button"
		},
		"3": {
			"id"          : "arm3",
			"container"   : $"Shop Arm/Arm3",
			"icon"        : $"Shop Arm/Arm3/Icon",
			"cost_and_buy": $"Shop Arm/Arm3/CostBuy",
			"cost"        : $"Shop Arm/Arm3/CostBuy/HBoxContainer/Cost",
			"buy_button"  : $"Shop Arm/Arm3/CostBuy/Buy_Button"
		}
	},
	"butterfly": {
		"1": {
			"id"          : "butterfly1",
			"container"   : $"Shop Butterfly/Upgrade1",
			"icon"        : $"Shop Butterfly/Upgrade1/Icon",
			"cost_and_buy": $"Shop Butterfly/Upgrade1/CostBuy",
			"cost"        : $"Shop Butterfly/Upgrade1/CostBuy/HBoxContainer/Cost",
			"buy_button"  : $"Shop Butterfly/Upgrade1/CostBuy/Buy_Button"
		},
		"2": {
			"id"          : "butterfly2",
			"container"   : $"Shop Butterfly/Upgrade2",
			"icon"        : $"Shop Butterfly/Upgrade2/Icon",
			"cost_and_buy": $"Shop Butterfly/Upgrade2/CostBuy",
			"cost"        : $"Shop Butterfly/Upgrade2/CostBuy/HBoxContainer/Cost",
			"buy_button"  : $"Shop Butterfly/Upgrade2/CostBuy/Buy_Button"
		},
		"3": {
			"id"          : "butterfly3",
			"container"   : $"Shop Butterfly/Upgrade3",
			"icon"        : $"Shop Butterfly/Upgrade3/Icon",
			"cost_and_buy": $"Shop Butterfly/Upgrade3/CostBuy",
			"cost"        : $"Shop Butterfly/Upgrade3/CostBuy/HBoxContainer/Cost",
			"buy_button"  : $"Shop Butterfly/Upgrade3/CostBuy/Buy_Button"
		},
		"4": {
			"id"          : "butterfly4",
			"container"   : $"Shop Butterfly/Upgrade4",
			"icon"        : $"Shop Butterfly/Upgrade4/Icon",
			"cost_and_buy": $"Shop Butterfly/Upgrade4/CostBuy",
			"cost"        : $"Shop Butterfly/Upgrade4/CostBuy/HBoxContainer/Cost",
			"buy_button"  : $"Shop Butterfly/Upgrade4/CostBuy/Buy_Button"
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

func buy_item(upgrade: Dictionary) -> void:
	#upgrade should be as shop_elements[shop][upgrade_number]
	var cost = int(upgrade["cost"].text)
	if score_bar.current_butterfly_count >= cost:
		score_bar.update_score(cost*-1)
		if "arm" in upgrade["id"]:
			player.update_arm_sprite(int(str(upgrade["id"]).get_slice("arm", 1)))
			update_shop("arm")
		elif "butterfly" in upgrade["id"]:
			if upgrade["id"] == "butterfly1":
				chocolate_rose_spawner.add_new_rose()
				butterfly_spawner.number_of_butterflies_each_wave += 1
				butterfly_spawner.update_max_butterflies()
				shop_butterfly_upgrade_levels[0] += 1
				upgrade["cost"].text = str(int(2 + 1.5 ** shop_butterfly_upgrade_levels[0]))
		
			elif upgrade["id"] == "butterfly2":
				butterfly_spawner.rizz_butterfly_chance += 0.05
				butterfly_spawner.time_between_waves -= 0.2
				shop_butterfly_upgrade_levels[1] += 1
				upgrade["cost"].text = str(int(2 + 1.5 ** shop_butterfly_upgrade_levels[1]))
		
			elif upgrade["id"] == "butterfly3":
				butterfly_spawner.improved_butterfly_chance += 0.05
				shop_butterfly_upgrade_levels[2] += 1
				upgrade["cost"].text = str(int(200 + 5 ** shop_butterfly_upgrade_levels[2]))
		
			elif upgrade["id"] == "butterfly4":
				player.arm_scale_level += 1
				player.update_arm_sprite()
				shop_butterfly_upgrade_levels[3] += 1
				upgrade["cost"].text = str(int(20 + 5 ** shop_butterfly_upgrade_levels[3]))
			
			update_shop("butterfly")
			

func _on_arm1_buy_button_pressed() -> void:
	buy_item(shop_elements["arm"]["1"])

func _on_arm2_buy_button_pressed() -> void:
	buy_item(shop_elements["arm"]["2"])

func _on_arm3_buy_button_pressed() -> void:
	buy_item(shop_elements["arm"]["3"])

func _on_upgrade1_buy_button_pressed() -> void:
	buy_item(shop_elements["butterfly"]["1"])

func _on_upgrade2_buy_button_pressed() -> void:
	buy_item(shop_elements["butterfly"]["2"])

func _on_upgrade3_buy_button_pressed() -> void:
	buy_item(shop_elements["butterfly"]["3"])

func _on_upgrade4_buy_button_pressed() -> void:
	buy_item(shop_elements["butterfly"]["4"])
