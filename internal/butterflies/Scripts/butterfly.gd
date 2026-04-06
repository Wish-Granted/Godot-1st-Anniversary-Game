extends RigidBody2D

@onready var sprite_butterfly = $CollisionPolygon2D/AnimatedSprite2D
@onready var collision_polygon = $CollisionPolygon2D
@onready var ray_cast = $RayCast2D

@onready var idle_timer = $Timer_Idle
@onready var movement_timer = $Timer_Movement
@onready var rotation_timer = $Timer_Rotation

@onready var player_node = get_tree().get_nodes_in_group("Player")[0]

var debug = false  

@export var min_size = 0.2 / 2.0 #size as a percentage of normal amount
@export var max_size = 0.5 / 2.0 #divided by two as sprite is too big mann

var is_idle = false
var is_rotating = false
var is_moving = false
var previous_action := "idle"

var move_speed := 400
var acceleration := 4
var deceleration := 0.5	

var target_rotation := 0.0
var rotation_speed := 2
var rotation_timeout = false

var butterfly_variation := "basic"
# basic, basic_rizz, improved, improved_rizz, dylan

var in_vacuum_area = false

func _ready() -> void:
	sprite_butterfly.play("%s_idle" %butterfly_variation)

	if len(get_meta_list()) > 1:
		collision_polygon.scale = Vector2(0,0)
		var size = randf_range(min_size, max_size)
		var size_tween = collision_polygon.create_tween()
		self.is_idle = true
		size_tween.tween_property(collision_polygon, "scale", Vector2(size, size), 1.5)
		size_tween.tween_callback(func(): do_idle())
		print_if_debug("butterfly_size: ", snappedf(size,0.01))

func _physics_process(delta: float) -> void:
	if not in_vacuum_area:
		# if doing nothing
		# if was idling - move
		# elif was moving - idle
		if not is_idle and not is_moving:
			if previous_action == "idle":
				do_movement()
			elif previous_action == "moving":
				do_idle()
		
		#moves towards the target rotation
		if is_rotating:
			rotation = lerp_angle(rotation, target_rotation, rotation_speed * delta)
		
		if snappedf(rotation, 0.01) == snappedf(target_rotation, 0.01) or rotation_timeout:
			
			if is_rotating:
				print_if_debug("finished rotating")
				movement_timer.wait_time = randf_range(0.5, 3.0)
				movement_timer.start()
				is_rotating = false
				sprite_butterfly.speed_scale = 1
			
			var forward_dir = Vector2.UP.rotated(rotation)
			var target_velocity
			var weight
			
			if is_moving:
				target_velocity = forward_dir * move_speed
				weight = acceleration
			elif not is_moving:
				target_velocity = Vector2.ZERO
				weight = deceleration # Default to slowing down
				
			linear_velocity = linear_velocity.lerp(target_velocity, weight * delta)
	else:
		
		global_position = global_position.lerp(player_node.sprite_arm.global_position, 0.01)

func get_valid_rotation(min_rotation: int, max_rotation: int) -> int:
	var new_rotation: int
	var attempts = 0	
	#checks if new rotation will be into the ground, if yes try again - up to 10 tries
	while attempts < 10:
		attempts += 1
		new_rotation = randi_range(min_rotation,max_rotation)
		ray_cast.rotation_degrees = new_rotation
		ray_cast.force_raycast_update()
		if not ray_cast.is_colliding():
			break

	print_if_debug("new rotation: ", new_rotation, " | attemps: ", attempts)
	return new_rotation

func do_movement():
	print_if_debug("Starting movement")
	is_moving = true
	previous_action = "moving"
	
	# get new rotation between -180 and 180 degrees
	target_rotation = deg_to_rad(get_valid_rotation(-180, 180))
	print_if_debug("Start rotate")
	sprite_butterfly.speed_scale = 0.7
	sprite_butterfly.play("%s_flapping" %butterfly_variation)
	is_rotating = true
	rotation_timer.start()

func _on_timer_movement_timeout() -> void:
	print_if_debug("end movement\n")
	is_moving = false
	rotation_timeout = false

func _on_timer_rotation_timeout() -> void:
	if is_rotating:
		print_if_debug("rotation timeout")
		rotation_timeout = true

func do_idle():
	print_if_debug("starting idle")
	is_idle = true
	previous_action = "idle"
	sprite_butterfly.play("%s_idle" %butterfly_variation)
	idle_timer.wait_time = randf_range(0.5, 3.0)
	idle_timer.start()
	await idle_timer.timeout
	
	is_idle = false
	print_if_debug("finished idle\n")

func print_if_debug(...args):
	if debug:
		var print_statement := ""		
		for arg in args:
			print_statement += str(arg)
		print(print_statement)
