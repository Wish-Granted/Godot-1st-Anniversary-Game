extends Node2D

@export var width : int

@onready var chocolate_rose_0 = $chocolate_rose_0

var total_roses := 0

func add_new_rose():
	total_roses += 1
	var new_rose = chocolate_rose_0.duplicate(true)
	
	var x_offset = randi_range(-960, 960)
	var new_rotation = randi_range(-20, 20)
	var new_size = randf_range(0.5,1.0)
	
	new_rose.name = "chocolate_rose_" + str(total_roses)
	new_rose.position.x = x_offset
	new_rose.rotation_degrees = new_rotation
	new_rose.scale = Vector2(new_size, new_size)
	new_rose.visible = true
	
	self.add_child(new_rose)
