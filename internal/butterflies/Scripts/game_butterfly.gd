extends Node2D

@onready var player_scene := $Player
@onready var butterfly_scene := "res://internal/butterflies/Scenes/butterfly.tscn"
@onready var butterfly_spawner_scene := $"Butterfly Spawner"

func _on_death_borders_body_entered(body: Node2D) -> void:
	print(body.name, " has been killed X_X")
	body.queue_free()
	
