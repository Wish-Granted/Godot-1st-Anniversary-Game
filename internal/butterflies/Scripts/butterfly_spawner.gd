extends Node2D

@export var width := 1920
@export var height := 1080 - 88 #approximate adjustment for window title/ taskbar

@onready var debug_border = $"Line Spawner Border"
const butterfly_scene = preload("res://internal/butterflies/Scenes/butterfly.tscn")
@onready var butterflies = $Butterflies
@onready var wave_timer = $"Wave Timer"

var total_alive_butterflies = 0
var total_butterflies_spawned = 0
var time_between_waves := 5
var number_of_butterflies_each_wave := 2
var max_butterflies = number_of_butterflies_each_wave * 5

func _ready() -> void:
	debug_border.clear_points()
	debug_border.add_point(Vector2(0,0))
	debug_border.add_point(Vector2(width,0))
	debug_border.add_point(Vector2(width,height))
	debug_border.add_point(Vector2(0,height))
	debug_border.add_point(Vector2(0,0))
	
	do_wave_loop()	

func spawn_butterfly_wave():
	var new_butterflies = []
	for butterfly in range(number_of_butterflies_each_wave):
		var spawn_position = Vector2()
		spawn_position.x = randi_range(0, width)
		spawn_position.y = randi_range(0, height)
		
		total_alive_butterflies += 1
		var new_butterfly = butterfly_scene.instantiate() 
		new_butterfly.name = "butterfly_" + str(total_butterflies_spawned)
		new_butterfly.position = spawn_position
		new_butterfly.rotation_degrees = randi_range(0,360)
		new_butterfly.visible = false
		new_butterflies.append(new_butterfly)
		butterflies.add_child(new_butterfly)
		total_butterflies_spawned += 1
		
	for butterfly in new_butterflies:
		butterfly.visible = true
		
func do_wave_loop():
	if total_alive_butterflies < max_butterflies:
		spawn_butterfly_wave()
	wave_timer.wait_time = time_between_waves
	wave_timer.start()
	await wave_timer.timeout
	do_wave_loop()
	
	
	
