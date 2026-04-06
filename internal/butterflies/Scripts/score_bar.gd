extends HBoxContainer

@export var icon_width: float = 64
@export var max_width: float = icon_width * 10

@onready var butterfly_counter := $Butterfly_Counter_Label
@onready var butterfly_display := $Butterfly_Display
const butterfly_icon = preload("res://internal/butterflies/Assests/butterfly_icon.png")

@onready var shop_buttons := $"../Shop_Buttons"
@onready var shop := $"../shop"

var current_butterfly_count = 0
var float_font_scale = 1.0
 
func _ready() -> void:
	update_score(9) # testing
	
func update_score(delta_butterflies: int) -> int:
	# 1. Add/ remove icons
	if delta_butterflies > 0:
		for i in range(delta_butterflies):
			var rect = TextureRect.new()
			rect.texture = butterfly_icon
			rect.expand_mode = TextureRect.EXPAND_KEEP_SIZE
			rect.stretch_mode = TextureRect.STRETCH_KEEP
			butterfly_display.add_child(rect)
	elif delta_butterflies < 0:
		for i in range(delta_butterflies*-1):
			print("killed")
			butterfly_display.get_child(0).free()

	current_butterfly_count += delta_butterflies
	butterfly_counter.text = str(current_butterfly_count) + " Butterflies "

	# 2. Calculate spacing
	var total_uncompressed_width = current_butterfly_count * icon_width
	
	if total_uncompressed_width > max_width:
		# Formula for negative separation to fit within max_width:
		# (max_width - (icon_width * count)) / (count - 1)
		if current_butterfly_count > 1:
			var overlap = (max_width - total_uncompressed_width) / (current_butterfly_count - 1)
			butterfly_display.add_theme_constant_override("separation", int(overlap))
	else:
		# Reset to default spacing if under the limit
		butterfly_display.add_theme_constant_override("separation", 0)
	
	if self.size.x*self.scale.x > 1850:
		while self.size.x*self.scale.x > 1850:
			float_font_scale *= 1.001
			butterfly_counter.label_settings.font_size = 64*float_font_scale
			butterfly_counter.label_settings.outline_size = 16*float_font_scale
			self.scale *= Vector2(0.999,0.999)
	
	if current_butterfly_count >= 10 and current_butterfly_count < 20:
		shop_buttons.show_shop_button("arm")
	elif current_butterfly_count >= 20:
		shop_buttons.show_shop_button("butterfly")
	
	return current_butterfly_count
