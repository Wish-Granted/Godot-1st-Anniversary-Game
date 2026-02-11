extends Node2D

@export var height := 1080
@export var width := 1920

@onready var border_X = $LineH
@onready var border_Y = $LineW

func _ready() -> void:
	border_X.remove_point(1)
	border_X.add_point(Vector2(width,0))
	border_Y.remove_point(1)
	border_Y.add_point(Vector2(0,height))
