extends Node2D

@onready var game_butterfly = $game_butterfly
@onready var intro = $Intro

@export var play_intro := true

func _ready() -> void:
	game_butterfly.load_game()
	if not play_intro:
		start_game()
	elif play_intro:
		start_intro()
		

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		game_butterfly.save_game()
		get_tree().quit()
	elif what == NOTIFICATION_APPLICATION_PAUSED:
		game_butterfly.save_game()
	
func start_intro() -> void:
	play_intro = false
		
	intro.visible = true
	intro.process_mode = Node.PROCESS_MODE_INHERIT
	
	game_butterfly.visible = false
	game_butterfly.process_mode = Node.PROCESS_MODE_DISABLED
	
func start_game():
	intro.process_mode = Node.PROCESS_MODE_DISABLED
	
	game_butterfly.process_mode = Node.PROCESS_MODE_INHERIT
	game_butterfly.main_camera.make_current()
	game_butterfly.visible = true
	
	intro.visible = false
