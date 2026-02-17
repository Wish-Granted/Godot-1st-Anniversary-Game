extends HBoxContainer

@export var icon_width: float = 64 
@export var max_width: float = icon_width * 10

@onready var butterfly_counter := $Butterfly_Counter_Label
@onready var butterfly_display := $Butterfly_Display
const butterfly_icon = preload("res://internal/butterflies/Assests/butterfly_icon.png")

@onready var shop_buttons := $"../Shop_Buttons"

var total_butterflies_collected = 0

func _ready() -> void:
	update_score(0)

func update_score(delta_butterflies: int) -> int:
	# 1. Add/ remove icons
	if delta_butterflies > 0:
		for i in range(delta_butterflies):
			var rect = TextureRect.new()
			rect.texture = butterfly_icon
			rect.expand_mode = TextureRect.EXPAND_KEEP_SIZE
			butterfly_display.add_child(rect)
	elif delta_butterflies < 0:
		for i in range(delta_butterflies):
			butterfly_display.get_child(0).queue_free()

	total_butterflies_collected += delta_butterflies
	butterfly_counter.text = str(total_butterflies_collected) + " Butterflies "

	# 2. Calculate spacing
	var total_uncompressed_width = total_butterflies_collected * icon_width
	
	if total_uncompressed_width > max_width:
		# Formula for negative separation to fit within max_width:
		# (max_width - (icon_width * count)) / (count - 1)
		if total_butterflies_collected > 1:
			var overlap = (max_width - total_uncompressed_width) / (total_butterflies_collected - 1)
			butterfly_display.add_theme_constant_override("separation", int(overlap))
	else:
		# Reset to default spacing if under the limit
		butterfly_display.add_theme_constant_override("separation", 0)
	
	if total_butterflies_collected == 5:
		shop_buttons.show_shop_button("arm")
	elif total_butterflies_collected == 10:
		shop_buttons.show_shop_button("butterfly")
	
	print(total_butterflies_collected)
	return total_butterflies_collected
