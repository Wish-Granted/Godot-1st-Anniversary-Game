extends Control

@onready var shop_gui = $"../shop"

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and shop_gui.visible:
		shop_gui.close_shop()
