extends CharacterBody2D

@onready var player := $"."
@onready var sprite_body := $AnimatedSprite2D_body

@onready var sprite_arm := $AnimatedSprite2D_arm
@onready var animation_player_arm_collision := $AnimatedSprite2D_arm/Arm_area/CollisionPolygon2D/Animation_ArmCollision

@onready var butterfly_spawner := $"../Butterfly Spawner"

@onready var shop := $"../shop"
@onready var score_bar := $"../Score_Bar"

@onready var vacuum_suck_collider = $AnimatedSprite2D_arm/Vacuum_area/Vacuum_suck_collider

var arm_ready := true
var arm_level := 0
var arm_scale_level = 0

const SPEED = 400
const JUMP_VELOCITY = -1600

func _ready() -> void:
	update_arm_sprite(arm_level)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		sprite_body.stop()
		velocity += get_gravity() * delta

	# Handle jump.
	if (Input.is_action_just_pressed("Space") or Input.is_action_just_pressed("W")) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("A", "D")
	if direction:
		sprite_body.play("run")
		if direction == 1:
			sprite_body.flip_h = true
			sprite_arm.flip_h = true
			sprite_arm.position.x = 4
		else:
			sprite_body.flip_h = false
			sprite_arm.flip_h = false
			sprite_arm.position.x = -4
			
		velocity.x = direction * SPEED
	else:
		sprite_body.play("idle")
		sprite_arm.position.y = ARM_RESTING_POSITION
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _process(_delta: float) -> void:
	
	if Input.is_action_pressed("Left Click") and shop.visible == false:
		do_arm_movement()
	else:
		sprite_arm.rotation_degrees = 0
		if arm_level == 3:
			sprite_arm.play("arm_3")
			vacuum_suck_collider.disabled = true

func do_arm_movement() -> void:
	sprite_arm.look_at(get_global_mouse_position())
	sprite_arm.rotation_degrees -= 92
	if arm_level == 3:
		sprite_arm.play("arm_3_active")
		vacuum_suck_collider.disabled = false		

const ARM_RESTING_POSITION := -322
const ARM_Y_POSITION_BY_FRAME_WHEN_WALKING := [
	-315,-307,-319,-331, -318, -302, -321, -331
]

func _on_animated_sprite_2d_body_frame_changed() -> void:
	if sprite_body.animation == "run":
		sprite_arm.position.y = ARM_Y_POSITION_BY_FRAME_WHEN_WALKING[sprite_body.frame]	

func _on_arm_area_body_entered(body: Node2D) -> void:
	print("player touched: ", body.name)
	if "butterfly" in body.name and Input.is_action_pressed("Left Click") and shop.visible == false:
		if body.get_meta("improved") == true or body.get_meta("dylan") == true:
			score_bar.update_score(10)
		else:
			score_bar.update_score(1)
		butterfly_spawner.total_alive_butterflies -= 1
		body.queue_free()

func update_arm_sprite(new_arm_level: int) -> void:
	arm_level = new_arm_level
	sprite_arm.scale = Vector2(1,1)
	if arm_level >= 2:
		sprite_arm.scale = Vector2(1,1.5)
		
	sprite_arm.scale += Vector2(0,0.5) * arm_scale_level
	sprite_arm.play("arm_%s" %arm_level)
	animation_player_arm_collision.play("arm_%s" %arm_level)
	
func _on_vacuum_area_body_entered(body: Node2D) -> void:
	if "butterfly" in body.name and Input.is_action_pressed("Left Click") and shop.visible == false:
		body.in_vacuum_area = true

func _on_vacuum_area_body_exited(body: Node2D) -> void:
	if "butterfly" in body.name and Input.is_action_pressed("Left Click") and shop.visible == false:
		body.in_vacuum_area = false
