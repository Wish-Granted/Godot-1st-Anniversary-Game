extends Node2D

@onready var player_scene := $Player
@onready var butterfly_scene := "res://internal/butterflies/Scenes/butterfly.tscn"
@onready var butterfly_spawner_scene := $"Butterfly Spawner"
@onready var score_bar := $Score_Bar
@onready var black_overlay := $Black_Overlay
@onready var game_manager := $".."
@onready var shop = $shop

@onready var main_camera = $Camera2D

func _ready() -> void:
	var tween_black_overlay = create_tween()
	tween_black_overlay.tween_property(black_overlay, "color", Color(0.0, 0.0, 0.0, 0), 3)

func _on_death_borders_body_entered(body: Node2D) -> void:
	print(body.name, " has been killed X_X")
	body.queue_free()
	butterfly_spawner_scene.total_alive_butterflies -= 1
	score_bar.update_score(1)

func save_game():
	return #debug
	var save_file = ConfigFile.new()
	var save_path = "user://save_butterfly.config"
	
	save_file.set_value("Progress", "arm_level", player_scene.arm_level)
	save_file.set_value("Progress", "shop_levels", shop.get_butterfly_shop_upgrade_levels())
	
	save_file.set_value("Progress", "current_butterfly_count", score_bar.current_butterfly_count)
	save_file.set_value("Progress", "total_butteflies_collected", score_bar.total_butterflies_collected)
		
	save_file.set_value("Settings", "play_intro", game_manager.play_intro)
	
	var error = save_file.save(save_path)
	if error != OK:
		print("ERROR SAVING CONFIG")
		
func load_game():
	var save_file = ConfigFile.new()
	var save_path = "user://save_butterfly.config"
	
	var error = save_file.load(save_path)
	
	if error != OK:
		return false
		
	player_scene.update_arm_sprite(save_file.get_value("Progress", "arm_level", 0))
	shop.load_butterfly_shop_upgrade_levels(save_file.get_value("Progress", "shop_levels", [0,0,0,0]))
	
	score_bar.update_score(save_file.get_value("Progress", "current_butterfly_count", 0))
	score_bar.total_butterflies_collected = save_file.get_value("Progress", "total_butteflies_collected", 0)
	
	game_manager.play_intro = save_file.get_value("Settings", "play_intro", true)
	
	
